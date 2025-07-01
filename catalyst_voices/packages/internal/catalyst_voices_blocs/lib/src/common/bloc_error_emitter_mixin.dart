import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixin that provides an error emitter.
///
/// It allows to emit errors to notify listeners.
/// But it is not altering the state of the bloc.
///
/// Useful when you want to notify listeners about some errors
/// that are not related to the state of the bloc.
mixin BlocErrorEmitterMixin<State> on BlocBase<State> implements ErrorEmitter {
  late final _errorController = StreamController<Object>.broadcast();

  @override
  Stream<Object> get errorStream => _errorController.stream;

  @override
  Future<void> close() async {
    await _errorController.close();
    return super.close();
  }

  void emitError(Object error) {
    if (isClosed) {
      throw StateError('Cannot emitError after calling close');
    }
    _errorController.add(error);
  }
}

/// An interface of an abstract error emitter.
abstract interface class ErrorEmitter {
  /// The asynchronous error stream that can be listened by error handlers.
  Stream<Object> get errorStream;
}
