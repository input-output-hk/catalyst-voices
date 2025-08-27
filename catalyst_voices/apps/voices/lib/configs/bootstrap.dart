import 'dart:async';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/app/view/app_splash_screen_manager.dart';
import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

const ReportingService _reportingService = _shouldUseSentry
    ? SentryReportingService()
    : NoOpReportingService();

const _shouldUseSentry = kReleaseMode || kProfileMode;

final _bootstrapLogger = Logger('Bootstrap');
final _flutterLogger = Logger('Flutter');
final _loggingService = LoggingService();
final _platformDispatcherLogger = Logger('PlatformDispatcher');
final _uncaughtZoneLogger = Logger('UncaughtZone');

/// Initializes the application before it can be run. Should setup all
/// the things which are necessary before the actual app is run,
/// either via [runApp] or injected into a test environment during
/// integration tests.
///
/// Initialization logic that is relevant for [runApp] scenario
/// only should be added to [_doBootstrapAndRun], not here.
Future<BootstrapArgs> bootstrap({
  GoRouter? router,
  AppEnvironment? environment,
}) async {
  await _loggingService.init();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  environment ??= AppEnvironment.fromEnv();
  final config = await _getAppConfig(env: environment.type);

  await _cleanupOldStorages();
  await _initCryptoUtils();
  await _reportingService.init(config: config.sentry);

  await Dependencies.instance.init(
    config: config,
    environment: environment,
    loggingService: _loggingService,
    reportingService: _reportingService,
  );

  //ignore: avoid_redundant_argument_values
  router ??= buildAppRouter(enableReporting: _shouldUseSentry);

  // Observer is very noisy on Logger. Enable it only if you want to debug
  // something
  Bloc.observer = AppBlocObserver(logOnChange: false);

  Dependencies.instance.get<ReportingServiceMediator>().init();
  Dependencies.instance.get<SyncManager>().start().ignore();

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
      final isNotSentryReporting = _reportingService is SentryReportingService;
      _reportUncaughtZoneError(error, stack, severe: isNotSentryReporting);
    },
  );
}

// TODO(damian-molinski): Add Isolate.current.addErrorListener
@visibleForTesting
GoRouter buildAppRouter({
  String? initialLocation,
  bool enableReporting = false,
}) {
  final observers = <NavigatorObserver>[];

  if (enableReporting) {
    final reportingService = Dependencies.instance.get<ReportingService>();
    final observer = reportingService.buildNavigatorObserver();
    if (observer != null) observers.add(observer);
  }

  return AppRouterFactory.create(
    initialLocation: initialLocation,
    observers: observers.isNotEmpty ? observers : null,
  );
}

@visibleForTesting
void registerConfig(AppConfig config) {
  Dependencies.instance.register(config);
}

@visibleForTesting
Future<void> registerDependencies({
  AppEnvironment environment = const AppEnvironment.dev(),
  LoggingService? loggingService,
  ReportingService reportingService = const NoOpReportingService(),
}) async {
  await Dependencies.instance.init(
    config: AppConfig.env(environment.type),
    environment: environment,
    loggingService: loggingService ?? NoOpLoggingService(),
    reportingService: reportingService,
  );
}

@visibleForTesting
Future<void> restartDependencies() async {
  await Dependencies.instance.reset;
}

Future<void> _cleanupOldStorages() async {
  await SecureUserStorage.clearPreviousVersions();
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

  FlutterError.onError = _reportFlutterError;
  PlatformDispatcher.instance.onError = _reportPlatformDispatcherError;

  final args = await bootstrap(environment: environment);
  var app = await builder(args);

  if (_shouldUseSentry) {
    app = SentryWidget(child: app);
  }

  runApp(app);
}

Future<AppConfig> _getAppConfig({
  required AppEnvironmentType env,
}) async {
  final api = ApiServices(env: env);
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

Future<void> _reportBootstrapError(Object error, StackTrace stack) async {
  _bootstrapLogger.severe('Error while bootstrapping', error, stack);
}

/// Flutter-specific assertion failures and contract violations.
Future<void> _reportFlutterError(FlutterErrorDetails details) async {
  _flutterLogger.severe(
    details.context?.toStringDeep(),
    details.exception,
    details.stack,
  );
}

/// Platform Dispatcher Errors reporting
bool _reportPlatformDispatcherError(Object error, StackTrace stack) {
  _platformDispatcherLogger.severe('Platform Error', error, stack);

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
    _uncaughtZoneLogger.severe('Uncaught Error', error, stack);
  } else {
    _uncaughtZoneLogger.finer('Uncaught Error', error, stack);
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
