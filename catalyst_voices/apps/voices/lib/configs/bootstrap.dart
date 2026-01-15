import 'dart:async';
import 'dart:core';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/app/app_initialization_choreographer.dart';
import 'package:catalyst_voices/app/view/app_splash_screen_manager.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

const ReportingService _reportingService = _shouldUseSentry
    ? SentryReportingService()
    : NoopReportingService();

const _shouldUseSentry = kReleaseMode;

var _bootstrapInitState = const _BootstrapState();
var _initialLocation = Uri();

final _loggerBootstrap = Logger('Bootstrap');
final _loggerFlutter = Logger('Flutter');
final _loggerPlatformDispatcher = Logger('PlatformDispatcher');
final _loggerUncaughtZone = Logger('UncaughtZone');

final _loggingService = LoggingService();

@visibleForTesting
AppConfig? get appConfig => _bootstrapInitState.appConfig;

Uri get initialLocation => _initialLocation;

@visibleForTesting
LoggingService get loggingService => _loggingService;

/// Initializes the application before it can be run. Should setup all
/// the things which are necessary before the actual app is run,
/// either via [runApp] or injected into a test environment during
/// integration tests.
///
/// Initialization logic that is relevant for [runApp] scenario
/// only should be added to [_doBootstrapAndRun], not here.
Future<BootstrapArgs> bootstrap({
  AppEnvironment? environment,
  String? initialLocation,
}) async {
  final bootstrapStartTimestamp = DateTimeExt.now(utc: true);

  await _loggingService.init();

  if (!_bootstrapInitState.didSetPathUrlStrategy) {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    setPathUrlStrategy();
    _bootstrapInitState = _bootstrapInitState.copyWith(didSetPathUrlStrategy: true);
  }

  EquatableConfig.stringify = kDebugMode;

  // app config
  final startConfigTimestamp = DateTimeExt.now(utc: true);
  environment ??= AppEnvironment.fromEnv();
  final config = await _getAppConfig(env: environment.type);
  _bootstrapInitState = _bootstrapInitState.copyWith(appConfig: Optional(config));

  if (config.stressTest.isEnabled) {
    _debugPrintStressTest();
  }

  final endConfigTimestamp = DateTimeExt.now(utc: true);

  await _initReportingService(config.sentry);

  await cleanUpStorages(onlyOld: true);
  if (!_bootstrapInitState.didInitializeCryptoUtils) {
    await _initCryptoUtils();
    _bootstrapInitState = _bootstrapInitState.copyWith(didInitializeCryptoUtils: true);
  }

  // profilers
  final profiler = _createProfiler(config);

  final startupProfiler = CatalystStartupProfiler(profiler)
    ..start(at: bootstrapStartTimestamp)
    ..appConfig(
      fromTo: DateRange(from: startConfigTimestamp, to: endConfigTimestamp),
    );

  await Dependencies.instance.init(
    config: config,
    environment: environment,
    loggingService: _loggingService,
    reportingService: _reportingService,
    profiler: profiler,
    startupProfiler: startupProfiler,
  );

  final router = buildAppRouter(initialLocation: initialLocation);
  _initialLocation = router.routeInformationProvider.value.uri;

  try {
    await const AppInitializationChoreographer()(config, _initialLocation);
  } catch (error, stack) {
    unawaited(_reportBootstrapError(error, stack));
  }

  return BootstrapArgs(
    routerConfig: router,
    sentryConfig: config.sentry,
  );
}

/// The entry point for Catalyst App,
/// initializes and runs the application.
///
/// Should configure dependency injection, setup logger and do
/// all the things which are necessary before the actual app is run.
///
/// You can customize the default app by providing
/// your own instance via [builder].
Future<void> bootstrapAndRun(
  AppEnvironment environment, [
  BootstrapWidgetBuilder builder = _defaultBuilder,
]) async {
  await _reportingService.runZonedGuarded(
    () => _safeBootstrapAndRun(environment, builder),
    (error, stack) {
      // not severe because Sentry will log it automatically.
      // ignore: prefer_const_declarations
      final isNotSentryReporting = _reportingService is! SentryReportingService;
      _reportUncaughtZoneError(error, stack, severe: isNotSentryReporting);
    },
  );
}

@visibleForTesting
GoRouter buildAppRouter({
  String? initialLocation,
}) {
  final observers = <NavigatorObserver>[];

  final reportingService = Dependencies.instance.get<ReportingService>();
  final observer = reportingService.buildNavigatorObserver();
  if (observer != null) observers.add(observer);

  return AppRouterFactory.create(
    initialLocation: initialLocation,
    observers: observers.isNotEmpty ? observers : null,
  );
}

@visibleForTesting
Future<void> cleanUpStorages({
  bool onlyOld = false,
}) async {
  await SecureUserStorage.clearPreviousVersions();
  if (onlyOld) {
    return;
  }

  assert(
    Dependencies.instance.isInitialized,
    'Dependencies not yet initialized!',
  );

  await Dependencies.instance.get<FlutterSecureStorage>().deleteAll();
  await Dependencies.instance.get<SharedPreferencesAsync>().clear();
}

@visibleForTesting
Future<void> cleanUpUserDataFromDatabase() async {
  final db = Dependencies.instance.get<CatalystDatabase>();

  await db.localDocumentsV2Dao.deleteWhere();
  await db.localMetadataDao.deleteWhere();
}

@visibleForTesting
void registerConfig(AppConfig config) {
  Dependencies.instance.register(config);
}

@visibleForTesting
Future<void> registerDependencies({
  AppEnvironment environment = const AppEnvironment.dev(),
  LoggingService? loggingService,
  ReportingService reportingService = const NoopReportingService(),
}) async {
  await Dependencies.instance.init(
    config: AppConfig.env(environment.type),
    environment: environment,
    loggingService: loggingService ?? NoopLoggingService(),
    reportingService: reportingService,
  );
}

/// Creates the appropriate profiler based on the current build mode.
///
/// Returns:
/// - [CatalystDeveloperProfiler] when running in profile mode
/// - [CatalystSentryProfiler] when running in release mode
/// - [CatalystNoopProfiler] for debug mode (no overhead)
CatalystProfiler _createProfiler(AppConfig config) {
  if (kProfileMode) {
    return config.profiler.console
        ? const CatalystProfiler.console()
        : CatalystProfiler.developer(config.profiler);
  }

  if (_shouldUseSentry) {
    return const CatalystProfiler.sentry();
  }

  return const CatalystProfiler.noop();
}

void _debugPrintStressTest() {
  if (!kProfileMode) {
    debugPrint('Warning. StressTest is enabled for non profile mode');
  } else {
    debugPrint('Running in StressTest environment');
  }
}

Widget _defaultBuilder(BootstrapArgs args) {
  return App(
    routerConfig: args.routerConfig,
  );
}

Future<void> _doBootstrapAndRun(
  AppEnvironment environment,
  BootstrapWidgetBuilder builder,
) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  AppSplashScreenManager.preserveSplashScreen(widgetsBinding);

  // TODO(damian-molinski): Add Isolate.current.addErrorListener
  FlutterError.onError = _reportFlutterError;
  PlatformDispatcher.instance.onError = _reportPlatformDispatcherError;

  final args = await bootstrap(environment: environment);
  var app = await builder(args);

  app = _reportingService.wrapApp(app);

  runApp(app);
}

Future<AppConfig> _getAppConfig({
  required AppEnvironmentType env,
}) async {
  final config = ApiConfig(env: env);
  final api = ApiServices.dio(config: config);
  final source = ApiConfigSource(api);
  final service = ConfigService(ConfigRepository(source));
  return service.getAppConfig(env: env);
}

Future<void> _initCryptoUtils() async {
  // Key derivation needs to be initialized before it can be used
  await CatalystKeyDerivation.init();

  CatalystPrivateKey.factory = const Bip32Ed25519XCatalystPrivateKeyFactory();
  CatalystPublicKey.factory = const Bip32Ed25519XCatalystPublicKeyFactory();
  CatalystSignature.factory = const Bip32Ed25519XCatalystSignatureFactory();
}

Future<void> _initReportingService(SentryConfig sentryConfig) async {
  await _reportingService.init(config: sentryConfig).onError(
    (error, stackTrace) {
      _loggerBootstrap.info(
        'Failed to initialize ReportingService. App will continue without error reporting.',
        error,
        stackTrace,
      );
    },
  );
}

Future<void> _reportBootstrapError(Object error, StackTrace stack) async {
  _loggerBootstrap.severe('Error while bootstrapping', error, stack);
}

/// Flutter-specific assertion failures and contract violations.
Future<void> _reportFlutterError(FlutterErrorDetails details) async {
  _loggerFlutter.severe(
    details.context?.toStringDeep(),
    details.exception,
    details.stack,
  );
}

/// Platform Dispatcher Errors reporting
bool _reportPlatformDispatcherError(Object error, StackTrace stack) {
  _loggerPlatformDispatcher.severe('Platform Error', error, stack);

  // return true to prevent default error handling
  return true;
}

/// Uncaught Errors reporting
void _reportUncaughtZoneError(
  Object error,
  StackTrace stack, {
  bool severe = true,
}) {
  if (severe) {
    _loggerUncaughtZone.severe('Uncaught Error', error, stack);
  } else {
    _loggerUncaughtZone.finer('Uncaught Error', error, stack);
  }
}

Future<void> _safeBootstrapAndRun(
  AppEnvironment environment,
  BootstrapWidgetBuilder builder,
) async {
  try {
    await _doBootstrapAndRun(environment, builder);
  } catch (error, stack) {
    await _reportBootstrapError(error, stack);
  }
}

typedef BootstrapWidgetBuilder = FutureOr<Widget> Function(BootstrapArgs args);

final class BootstrapArgs {
  final RouterConfig<Object> routerConfig;
  final SentryConfig sentryConfig;

  BootstrapArgs({
    required this.routerConfig,
    required this.sentryConfig,
  });
}

class _BootstrapState extends Equatable {
  final AppConfig? appConfig;
  final bool didInitializeCryptoUtils;
  final bool didSetPathUrlStrategy;

  const _BootstrapState({
    this.appConfig,
    this.didInitializeCryptoUtils = false,
    this.didSetPathUrlStrategy = false,
  });

  @override
  List<Object?> get props => [
    appConfig,
    didInitializeCryptoUtils,
    didSetPathUrlStrategy,
  ];

  _BootstrapState copyWith({
    Optional<AppConfig>? appConfig,
    bool? didInitializeCryptoUtils,
    bool? didSetPathUrlStrategy,
  }) {
    return _BootstrapState(
      appConfig: appConfig.dataOr(this.appConfig),
      didInitializeCryptoUtils: didInitializeCryptoUtils ?? this.didInitializeCryptoUtils,
      didSetPathUrlStrategy: didSetPathUrlStrategy ?? this.didSetPathUrlStrategy,
    );
  }
}
