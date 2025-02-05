import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

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

final class AccountToKeychainUnlockTransformer
    extends StreamTransformerBase<Account?, bool> {
  AccountToKeychainUnlockTransformer();

  @override
  Stream<bool> bind(Stream<Account?> stream) {
    return Stream.eventTransformed(
      stream,
      _AccountToKeychainUnlockStreamSink.new,
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

final class _AccountToKeychainUnlockStreamSink implements EventSink<Account?> {
  final EventSink<bool> _outputSink;
  StreamSubscription<bool>? _streamSub;

  _AccountToKeychainUnlockStreamSink(this._outputSink);

  @override
  void add(Account? event) {
    final stream = event?.keychain.watchIsUnlocked ?? Stream.value(false);

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
