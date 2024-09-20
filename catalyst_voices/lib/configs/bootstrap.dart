import 'dart:async';
import 'dart:developer';

import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:catalyst_voices/configs/sentry_service.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/guards/milestone_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

typedef BootstrapWidgetBuilder = FutureOr<Widget> Function(BootstrapArgs args);

final class BootstrapArgs {
  final RouterConfig<Object> routerConfig;

  BootstrapArgs({
    required this.routerConfig,
  });
}

// TODO(damian-molinski): Add PlatformDispatcher.instance.onError
// TODO(damian-molinski): Add Isolate.current.addErrorListener
// TODO(damian-molinski): Add runZonedGuarded
// TODO(damian-molinski): Add Global try-catch
//
/// The entry point for Catalyst Voices,
/// initializes and runs the application.
///
/// Should configure dependency injection, setup logger and do
/// all the things which are necessary before the actual app is run.
///
/// You can customize the default app by providing
/// your own instance via [builder].
Future<void> bootstrapAndRun([
  BootstrapWidgetBuilder builder = _appBuilder,
]) async {
  // There's no need to call WidgetsFlutterBinding.ensureInitialized()
  // since this is already done internally by SentryFlutter.init()
  // More info here: https://github.com/getsentry/sentry-dart/issues/2063
  if (!kReleaseMode) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  FlutterError.onError = (details) {
    log(
      details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  final args = await bootstrap();

  await _runApp(await builder(args));
}

/// Initializes the application before it can be run. Should setup all
/// the things which are necessary before the actual app is run,
/// either via [runApp] or injected into a test environment during
/// integration tests.
///
/// Initialization logic that is relevant for [runApp] scenario
/// only should be added to [bootstrapAndRun], not here.
Future<BootstrapArgs> bootstrap() async {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  final router = AppRouter.init(
    guards: const [
      MilestoneGuard(),
    ],
  );

  Bloc.observer = AppBlocObserver();

  await Dependencies.instance.init();

  return BootstrapArgs(routerConfig: router);
}

Future<void> _runApp(Widget app) async {
  if (kReleaseMode) {
    await SentryService.init(app);
  } else {
    runApp(app);
  }
}

Widget _appBuilder(BootstrapArgs args) {
  return App(
    routerConfig: args.routerConfig,
  );
}
