import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AppBlocObserver extends BlocObserver {
  final _logger = Logger('AppBlocObserver');

  AppBlocObserver();

  @override
  void onChange(
    BlocBase<dynamic> bloc,
    Change<dynamic> change,
  ) {
    super.onChange(bloc, change);
    _logger.info('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.warning('onError(${bloc.runtimeType})', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
