import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final class DummyCatalystIdFactory {
  DummyCatalystIdFactory._();

  static CatalystId create({
    CatalystIdHost host = CatalystIdHost.cardano,
    String? username = 'Dummy',
    AccountRole? role,
    int? nonce,
  }) {
    /* cSpell:disable */
    final role0KeyBytes =
        base64UrlNoPadDecode('FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE');
    /* cSpell:enable */

    final role0Key = _DummyCatalystPublicKeyFactory().create(role0KeyBytes);

    return CatalystId(
      host: host.host,
      username: username,
      role0Key: role0Key.publicKeyBytes,
      role: role,
      nonce: nonce ?? Random().nextInt(50000),
    );
  }

  @visibleForTesting
  static void registerDummyKeyFactory() {
    CatalystPublicKey.factory = _DummyCatalystPublicKeyFactory();
  }
}

@immutable
class _DummyCatalystPublicKey implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  const _DummyCatalystPublicKey({required this.bytes});

  @override
  int get hashCode => const DeepCollectionEquality().hash(bytes);

  @override
  Uint8List get publicKeyBytes => bytes;

  @override
  bool operator ==(Object other) {
    if (other is! _DummyCatalystPublicKey) return false;

    return const DeepCollectionEquality().equals(other.bytes, bytes);
  }

  @override
  Future<bool> verify(
    Uint8List data, {
    required CatalystSignature signature,
  }) {
    return Future(() => true);
  }
}

class _DummyCatalystPublicKeyFactory implements CatalystPublicKeyFactory {
  @override
  CatalystPublicKey create(Uint8List bytes) {
    return _DummyCatalystPublicKey(bytes: bytes);
  }
}
