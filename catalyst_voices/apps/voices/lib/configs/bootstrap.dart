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
import 'package:url_strategy/url_strategy.dart';

const CatalystProfiler profiler = _shouldUseSentry
    ? CatalystSentryProfiler()
    : CatalystNoopProfiler();
const ReportingService _reportingService = _shouldUseSentry
    ? SentryReportingService()
    : NoopReportingService();

const _shouldUseSentry = kReleaseMode || kProfileMode;

final _loggerBootstrap = Logger('Bootstrap');
final _loggerFlutter = Logger('Flutter');
final _loggerPlatformDispatcher = Logger('PlatformDispatcher');
final _loggerUncaughtZone = Logger('UncaughtZone');
final _loggingService = LoggingService();

CatalystProfilerTimeline? _startupTimeline;

CatalystProfilerTimeline get startupTimeline {
  assert(_startupTimeline != null, 'startupTimeline not initialized yet!');
  return _startupTimeline!;
}

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
  final bootstrapStartTimestamp = DateTimeExt.now(utc: true);

  await _loggingService.init();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  final startConfigTimestamp = DateTimeExt.now(utc: true);
  environment ??= AppEnvironment.fromEnv();
  final config = await _getAppConfig(env: environment.type);
  final endConfigTimestamp = DateTimeExt.now(utc: true);

  await _reportingService.init(config: config.sentry);
  await _cleanupOldStorages();
  await _initCryptoUtils();

  _startupTimeline = profiler.startTransaction(
    'Startup',
    arguments: CatalystProfilerTimelineArguments(
      operation: 'initialisation',
      description:
          'Measuring how long it takes from flutter code '
          'execution to Application widget beaning ready.',
      startTimestamp: bootstrapStartTimestamp,
    ),
  );
  startupTimeline
      .startTask(
        'config',
        arguments: CatalystProfilerTimelineTaskArguments(
          description: 'How long it takes for app config resolve',
          startTimestamp: startConfigTimestamp,
        ),
      )
      .finish(
        arguments: CatalystProfilerTimelineTaskFinishArguments(endTimestamp: endConfigTimestamp),
      );

  await Dependencies.instance.init(
    config: config,
    environment: environment,
    loggingService: _loggingService,
    reportingService: _reportingService,
  );

  router ??= buildAppRouter();

  // Observer is very noisy on Logger. Enable it only if you want to debug
  // something
  Bloc.observer = AppBlocObserver(logOnChange: false);

  Dependencies.instance.get<ReportingServiceMediator>().init();
  _startSyncManager().ignore();

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

// TODO(damian-molinski): Add Isolate.current.addErrorListener
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

  app = _reportingService.wrapApp(app);

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

Future<void> _startSyncManager() async {
  final task = startupTimeline.startTask('documents_sync');
  final args = CatalystProfilerTimelineTaskFinishArguments();

  try {
    await Dependencies.instance.get<SyncManager>().start();
    args.status = 'completed';
  } catch (_, _) {
    args.status = 'failed';
  } finally {
    task.finish();
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
