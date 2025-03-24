import 'dart:async';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:catalyst_voices/configs/sentry_service.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/guards/milestone_guard.dart';
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
}) async {
  _loggingService
    ..level = kDebugMode ? Level.FINER : Level.OFF
    ..printLogs = kDebugMode;

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  final configService = ConfigService(ConfigRepository());
  final config = await configService
      .getAppConfig()
      .onError((error, stackTrace) => const AppConfig());

  await _cleanupOldStorages();
  await registerDependencies(config: config);
  await _initCryptoUtils();

  router ??= buildAppRouter();

  Bloc.observer = AppBlocObserver();

  Dependencies.instance.get<SyncManager>().start().ignore();

  return BootstrapArgs(routerConfig: router);
}

/// The entry point for Catalyst Voices,
/// initializes and runs the application.
///
/// Should configure dependency injection, setup logger and do
/// all the things which are necessary before the actual app is run.
///
/// You can customize the default app by providing
/// your own instance via [builder].
Future<void> bootstrapAndRun([
  BootstrapWidgetBuilder builder = _defaultBuilder,
]) async {
  await runZonedGuarded(
    () => _safeBootstrapAndRun(builder),
    _reportUncaughtZoneError,
  );
}

// TODO(damian-molinski): Add Isolate.current.addErrorListener
@visibleForTesting
GoRouter buildAppRouter({
  String? initialLocation,
}) {
  return AppRouter.init(
    initialLocation: initialLocation,
    guards: const [
      MilestoneGuard(),
    ],
  );
}

@visibleForTesting
Future<void> registerDependencies({required AppConfig config}) async {
  if (!Dependencies.instance.isInitialized) {
    await Dependencies.instance.init(config: config);
  }
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

Future<void> _doBootstrapAndRun(BootstrapWidgetBuilder builder) async {
  // There's no need to call WidgetsFlutterBinding.ensureInitialized()
  // since this is already done internally by SentryFlutter.init()
  // More info here: https://github.com/getsentry/sentry-dart/issues/2063
  if (!kReleaseMode) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  FlutterError.onError = _reportFlutterError;
  PlatformDispatcher.instance.onError = _reportPlatformDispatcherError;

  final args = await bootstrap();
  final app = await builder(args);
  await _runApp(app);
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

Future<void> _runApp(Widget app) async {
  if (kReleaseMode) {
    await SentryService.init(app);
  } else {
    runApp(app);
  }
}

Future<void> _safeBootstrapAndRun(BootstrapWidgetBuilder builder) async {
  try {
    await _doBootstrapAndRun(builder);
  } catch (error, stack) {
    await _reportBootstrapError(error, stack);
  }
}

typedef BootstrapWidgetBuilder = FutureOr<Widget> Function(BootstrapArgs args);

final class BootstrapArgs {
  final RouterConfig<Object> routerConfig;

  BootstrapArgs({
    required this.routerConfig,
  });
}
