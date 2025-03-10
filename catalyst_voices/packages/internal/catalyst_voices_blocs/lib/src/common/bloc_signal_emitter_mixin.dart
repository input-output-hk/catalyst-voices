import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocSignalEmitterMixin<Signal extends Object, State> on BlocBase<State>
    implements SignalEmitter<Signal> {
  late final _signalController = StreamController<Signal>.broadcast();

  @override
  Stream<Signal> get signalStream => _signalController.stream;

  @override
  Future<void> close() async {
    await _signalController.close();
    return super.close();
  }

  void emitSignal(Signal signal) {
    if (isClosed) {
      throw StateError('Cannot emitSignal after calling close');
    }
    _signalController.add(signal);
  }
}

/// An interface of an abstract signal emitter.
///
/// It allows to edit events aka signals to notify listeners.
abstract interface class SignalEmitter<Signal extends Object> {
  /// The asynchronous signal stream that can be listened by signal handlers.
  Stream<Signal> get signalStream;
}
