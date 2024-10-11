import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocErrorEmitterMixin<State> on BlocBase<State> {
  late final _errorController = StreamController<Object>.broadcast();

  Stream<Object> get errorStream => _errorController.stream;

  void emitError(Object error) {
    if (isClosed) {
      throw StateError('Cannot emitError after calling close');
    }
    _errorController.add(error);
  }

  @override
  Future<void> close() async {
    await _errorController.close();
    return super.close();
  }
}
