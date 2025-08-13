import 'dart:async';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/app/view/app_splash_screen_manager.dart';
import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:catalyst_voices/configs/sentry_service.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

var _bootstrapInitState = const _BootstrapState();

final _bootstrapLogger = Logger('Bootstrap');
final _flutterLogger = Logger('Flutter');
final _loggingService = LoggingService();
final _platformDispatcherLogger = Logger('PlatformDispatcher');
final _uncaughtZoneLogger = Logger('UncaughtZone');

@visibleForTesting
AppConfig? get appConfig => _bootstrapInitState.appConfig;

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
  await _loggingService.init();

  if (!_bootstrapInitState.didSetPathUrlStrategy) {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    setPathUrlStrategy();
    _bootstrapInitState = _bootstrapInitState.copyWith(didSetPathUrlStrategy: true);
  }

  environment ??= AppEnvironment.fromEnv();

  await cleanUpStorages(onlyOld: true);
  await Dependencies.instance.init(environment: environment, loggingService: _loggingService);

  if (!_bootstrapInitState.didInitializeCryptoUtils) {
    await _initCryptoUtils();
    _bootstrapInitState = _bootstrapInitState.copyWith(didInitializeCryptoUtils: true);
  }

  final configSource = ApiConfigSource(Dependencies.instance.get());
  final configService = ConfigService(ConfigRepository(configSource));
  final config = await configService.getAppConfig(env: environment.type);

  _bootstrapInitState = _bootstrapInitState.copyWith(appConfig: Optional(config));
  Dependencies.instance.registerConfig(config);

  final router = AppRouterFactory.create(initialLocation: initialLocation);

  // Observer is very noisy on Logger. Enable it only if you want to debug
  // something
  Bloc.observer = AppBlocObserver(logOnChange: false);

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
  await runZonedGuarded(
    () => _safeBootstrapAndRun(environment, builder),
    _reportUncaughtZoneError,
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

  await db.draftsDao.deleteWhere();
  await db.favoritesDao.deleteAll();
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
  final app = await builder(args);
  await _runApp(app, sentryConfig: args.sentryConfig);
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
void _reportUncaughtZoneError(Object error, StackTrace stack) {
  _uncaughtZoneLogger.severe('Uncaught Error', error, stack);
}

Future<void> _runApp(
  Widget app, {
  required SentryConfig sentryConfig,
}) async {
  if (kReleaseMode) {
    await SentryService.init(app, config: sentryConfig);
  } else {
    runApp(app);
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
