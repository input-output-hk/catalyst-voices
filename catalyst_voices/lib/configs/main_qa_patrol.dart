import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();
  Bloc.observer = AppBlocObserver();
}
