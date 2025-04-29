//ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';

/// An interface of an abstract signal handler.
abstract interface class SignalHandler<Signal extends Object> {
  void handleSignal(Signal signal);
}

/// A convenient mixin that subscribes to the [SignalEmitter]
/// obtained from the [signalEmitter] and calls the [handleSignal].
///
/// After the widget is disposed the signal stream is disposed too.
mixin SignalHandlerStateMixin<
    Emitter extends SignalEmitter<Signal>,
    Signal extends Object,
    T extends StatefulWidget> on State<T> implements SignalHandler<Signal> {
  StreamSubscription<Signal>? _signalSub;

  /// A method that can be overridden to provide a custom error emitter.
  ///
  /// If this method is not overriden then the emitter of type [Emitter]
  /// must be provided in a widget tree so that context.read can find it.
  Emitter get signalEmitter => context.read<Emitter>();

  @override
  void dispose() {
    unawaited(_signalSub?.cancel());
    _signalSub = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _signalSub = signalEmitter.signalStream.listen(handleSignal);
  }
}
