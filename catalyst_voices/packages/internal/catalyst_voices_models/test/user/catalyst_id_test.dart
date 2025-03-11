import 'dart:convert';

import 'package:catalyst_voices_models/src/crypto/catalyst_key_factory.dart';
import 'package:catalyst_voices_models/src/crypto/catalyst_public_key.dart';
import 'package:catalyst_voices_models/src/user/account_role.dart';
import 'package:catalyst_voices_models/src/user/catalyst_id.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

/* cSpell:disable */
void main() {
  group(CatalystId, () {
    late CatalystPublicKey role0Key;

    setUpAll(() {
      CatalystPublicKey.factory = _FakeCatalystPublicKeyFactory();

      final role0KeyBytes =
          base64Decode('FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=');
      role0Key = CatalystPublicKey.factory.create(role0KeyBytes);
    });

    test('should create CatalystId instance correctly', () {
      final catalystId = CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'testuser',
        nonce: 12345678,
        role0Key: role0Key,
        role: AccountRole.proposer,
        rotation: 2,
        encrypt: true,
      );

      expect(catalystId.host, equals(CatalystIdHost.cardano.host));
      expect(catalystId.username, equals('testuser'));
      expect(catalystId.nonce, equals(12345678));
      expect(catalystId.role0Key, equals(role0Key));
      expect(catalystId.role, equals(AccountRole.proposer));
      expect(catalystId.rotation, equals(2));
      expect(catalystId.encrypt, isTrue);
    });

    test('should create minimal $CatalystId instance correctly', () {
      final catalystId = CatalystId(
        host: CatalystIdHost.cardano.host,
        role0Key: role0Key,
      );

      expect(catalystId.host, equals(CatalystIdHost.cardano.host));
      expect(catalystId.username, isNull);
      expect(catalystId.nonce, isNull);
      expect(catalystId.role0Key, equals(role0Key));
      expect(catalystId.role?.number, isNull);
      expect(catalystId.rotation, isNull);
      expect(catalystId.encrypt, isFalse);
    });

    test('should create minimal $CatalystId instance with username correctly',
        () {
      final catalystId = CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'john',
        role0Key: role0Key,
      );

      expect(catalystId.host, equals(CatalystIdHost.cardano.host));
      expect(catalystId.username, equals('john'));
      expect(catalystId.nonce, isNull);
      expect(catalystId.role0Key, equals(role0Key));
      expect(catalystId.role?.number, isNull);
      expect(catalystId.rotation, isNull);
      expect(catalystId.encrypt, isFalse);
    });

    test('should parse minimal $CatalystId from Uri correctly', () {
      final uri = Uri.parse(
        'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
      );

      final catalystId = CatalystId.fromUri(uri);
      expect(catalystId.host, equals(CatalystIdHost.cardano.host));
      expect(catalystId.username, isNull);
      expect(catalystId.nonce, isNull);
      expect(catalystId.role0Key, isNotNull);
      expect(catalystId.role?.number, isNull);
      expect(catalystId.rotation, isNull);
      expect(catalystId.encrypt, isFalse);
    });

    test('should parse minimal $CatalystId with username from Uri correctly',
        () {
      final uri = Uri.parse(
        'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
      );

      final catalystId = CatalystId.fromUri(uri);
      expect(catalystId.host, equals(CatalystIdHost.cardanoPreprod.host));
      expect(catalystId.username, equals('john'));
      expect(catalystId.nonce, isNull);
      expect(catalystId.role0Key, isNotNull);
      expect(catalystId.role?.number, isNull);
      expect(catalystId.rotation, isNull);
      expect(catalystId.encrypt, isFalse);
    });

    test('should parse $CatalystId from Uri correctly', () {
      final uri = Uri.parse(
        'id.catalyst://testuser:12345678@cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=/1/2#encrypt',
      );

      final catalystId = CatalystId.fromUri(uri);
      expect(catalystId.host, equals(CatalystIdHost.cardano.host));
      expect(catalystId.username, equals('testuser'));
      expect(catalystId.nonce, equals(12345678));
      expect(catalystId.role0Key, isNotNull);
      expect(catalystId.role?.number, equals(1));
      expect(catalystId.rotation, equals(2));
      expect(catalystId.encrypt, isTrue);
    });

    test('should convert $CatalystId to Uri correctly', () {
      final catalystId = CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'testuser',
        nonce: 12345678,
        role0Key: role0Key,
        role: AccountRole.fromNumber(1),
        rotation: 2,
        encrypt: true,
      );

      final uri = catalystId.toUri();
      expect(uri.scheme, 'id.catalyst');
      expect(uri.host, 'cardano');
      expect(uri.userInfo, 'testuser:12345678');
      expect(uri.fragment, 'encrypt');
      expect(
        uri.path,
        equals('/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=/1/2'),
      );
    });

    test('should format minimal $CatalystId to Uri correctly', () {
      final catalystId = CatalystId(
        host: CatalystIdHost.cardano.host,
        role0Key: role0Key,
        nonce: 123456,
      );

      final formattedId = catalystId.toUri().toStringWithoutScheme();
      expect(
        formattedId,
        equals(
          ':123456@cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
        ),
      );
    });
  });
}

class _FakeCatalystPublicKeyFactory extends Fake
    implements CatalystPublicKeyFactory {
  @override
  CatalystPublicKey create(Uint8List bytes) {
    return _FakeCatalystPublicKey(bytes: bytes);
  }
}

@immutable
class _FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPublicKey({required this.bytes});

  @override
  int get hashCode => const DeepCollectionEquality().hash(bytes);

  @override
  bool operator ==(Object other) {
    if (other is! _FakeCatalystPublicKey) return false;

    return const DeepCollectionEquality().equals(other.bytes, bytes);
  }
}
/* cSpell:enable */
