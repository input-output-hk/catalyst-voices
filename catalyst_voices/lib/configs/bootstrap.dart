import 'dart:async';
import 'dart:developer';

import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

/// Initializes and runs the application provided by the [builder].
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  FlutterError.onError = (details) {
    log(
      details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  Bloc.observer = AppBlocObserver();

  runApp(await builder());
}

/// Initializer for integration tests, similar to [bootstrap] but:
/// - Must not  call [WidgetsFlutterBinding.ensureInitialized].
/// - Must not call [runApp].
/// - Must not override [FlutterError.onError].
/// - Must be synced with [bootstrap], to run exactly the same
///   initialization logic except for the above exclusions.
Future<void> bootstrapForTests() async {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();
  Bloc.observer = AppBlocObserver();
}
