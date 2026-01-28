import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

abstract final class CatalystIdFactory {
  CatalystIdFactory._();

  static CatalystId create({
    String? username,
    CatalystIdHost host = CatalystIdHost.cardanoPreprod,
    int role0KeySeed = 0,
  }) {
    final role0Key = Uint8List.fromList(List.filled(32, role0KeySeed));

    return CatalystId(
      host: host.host,
      role0Key: role0Key,
      username: username,
    );
  }

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
