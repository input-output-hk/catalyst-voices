import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logging and debugging class for working with [Bloc]'s and [Cubit]'s.
final class AppBlocObserver extends BlocObserver {
  final _logger = Logger('AppBlocObserver');
  final bool logOnChange;

  AppBlocObserver({
    this.logOnChange = true,
  });

  @override
  void onChange(
    BlocBase<dynamic> bloc,
    Change<dynamic> change,
  ) {
    super.onChange(bloc, change);
    if (logOnChange) {
      _logger.finest('onChange(${bloc.runtimeType}, $change)');
    }
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
