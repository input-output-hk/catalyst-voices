import 'dart:async';

import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:catalyst_voices/configs/sentry_service.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/guards/milestone_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

final _loggingService = LoggingService();

final _bootstrapLogger = Logger('Bootstrap');
final _flutterLogger = Logger('Flutter');
final _platformDispatcherLogger = Logger('PlatformDispatcher');
final _uncaughtZoneLogger = Logger('UncaughtZone');

typedef BootstrapWidgetBuilder = FutureOr<Widget> Function(BootstrapArgs args);

final class BootstrapArgs {
  final RouterConfig<Object> routerConfig;

  BootstrapArgs({
    required this.routerConfig,
  });
}

// TODO(damian-molinski): Add Isolate.current.addErrorListener
Future<void> bootstrap([
  BootstrapWidgetBuilder builder = _defaultBuilder,
]) async {
  runZonedGuarded(
    () => _safeBootstrap(builder),
    _reportUncaughtZoneError,
  );
}

Future<void> _safeBootstrap(BootstrapWidgetBuilder builder) async {
  try {
    await _doBootstrap(builder);
  } catch (error, stack) {
    await _reportBootstrapError(error, stack);
  }
}

Future<void> _doBootstrap(BootstrapWidgetBuilder builder) async {
  // There's no need to call WidgetsFlutterBinding.ensureInitialized()
  // since this is already done internally by SentryFlutter.init()
  // More info here: https://github.com/getsentry/sentry-dart/issues/2063
  if (!kReleaseMode) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  _loggingService
    ..level = kDebugMode ? Level.ALL : Level.OFF
    ..printLogs = kDebugMode;

  FlutterError.onError = _reportFlutterError;
  PlatformDispatcher.instance.onError = _reportPlatformDispatcherError;

  await Dependencies.instance.init();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  final router = AppRouter.init(
    guards: const [
      MilestoneGuard(),
    ],
  );

  Bloc.observer = AppBlocObserver();

  final args = BootstrapArgs(routerConfig: router);
  final app = await builder(args);

  await _runApp(app);
}

Future<void> _runApp(Widget app) async {
  if (kReleaseMode) {
    await SentryService.init(app);
  } else {
    runApp(app);
  }
}

Widget _defaultBuilder(BootstrapArgs args) {
  return App(
    routerConfig: args.routerConfig,
  );
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
  return true;
}

/// Uncaught Errors reporting
void _reportUncaughtZoneError(Object error, StackTrace stack) {
  _uncaughtZoneLogger.severe('Uncaught Error', error, stack);
}
