import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// An interface of an abstract error emitter.
abstract interface class ErrorEmitter {
  /// The asynchronous error stream that can be listened by error handlers.
  Stream<Object> get errorStream;
}

mixin BlocErrorEmitterMixin<State> on BlocBase<State> implements ErrorEmitter {
  late final _errorController = StreamController<Object>.broadcast();

  @override
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
