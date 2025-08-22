import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';

extension BlocExtensions<State> on BlocBase<State> {
  /// Streams the bloc state.
  ///
  /// Emits the initial [state] whenever a subscription is made,
  /// contrary to [stream] which does not emit it.
  Stream<State> watchState() async* {
    yield state;
    yield* stream;
  }
}
