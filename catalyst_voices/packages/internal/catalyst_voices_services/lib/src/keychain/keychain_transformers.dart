import 'dart:async';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class KeychainToUnlockTransformer
    extends StreamTransformerBase<Keychain?, bool> {
  KeychainToUnlockTransformer();

  @override
  Stream<bool> bind(Stream<Keychain?> stream) {
    return Stream.eventTransformed(
      stream,
      _KeychainUnlockStreamSink.new,
    );
  }
}

final class _KeychainUnlockStreamSink implements EventSink<Keychain?> {
  final EventSink<bool> _outputSink;
  StreamSubscription<bool>? _streamSub;

  _KeychainUnlockStreamSink(this._outputSink);

  @override
  void add(Keychain? event) {
    final stream = event?.watchIsUnlocked ?? Stream.value(false);

    unawaited(_streamSub?.cancel());
    _streamSub = stream.listen(_outputSink.add);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _outputSink.addError(error, stackTrace);
  }

  @override
  void close() {
    unawaited(_streamSub?.cancel());
    _streamSub = null;
    _outputSink.close();
  }
}
