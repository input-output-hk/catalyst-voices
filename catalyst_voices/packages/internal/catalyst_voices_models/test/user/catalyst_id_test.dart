import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

/* cSpell:disable */
void main() {
  group(CatalystId, () {
    late Uint8List role0Key;

    setUpAll(() {
      role0Key =
          base64UrlNoPadDecode('FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE');
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
        equals('/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE/1/2'),
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
          ':123456@cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE',
        ),
      );
    });

    test('should ignore username when checking comparing significant part', () {
      // Given
      final idOne = CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'testuser',
        role0Key: role0Key,
      );
      final idTwo = idOne.copyWith(username: const Optional('developer'));

      // When
      final significantSame = idOne.toSignificant() == idTwo.toSignificant();

      // Then
      expect(significantSame, isTrue);
    });

    test('different host makes id significant different', () {
      // Given
      final idOne = CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'testuser',
        role0Key: role0Key,
      );
      final idTwo = idOne.copyWith(host: CatalystIdHost.cardanoPreprod.host);

      // When
      final significantSame = idOne.toSignificant() == idTwo.toSignificant();

      // Then
      expect(significantSame, isFalse);
    });

    test('isSameRegistration compares only role0Key', () {
      // Given
      final idOne = CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'testuser',
        role0Key: role0Key,
      );
      final idTwo = idOne.copyWith(host: CatalystIdHost.cardanoPreprod.host);

      // When
      final isSameRegistration = idOne.isSameRegistration(idTwo);

      // Then
      expect(isSameRegistration, isTrue);
    });

    test('username with spaces is decoded correctly', () {
      const rawUri = 'id.catalyst://'
          'damian%20m@cardano/'
          'FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE';
      final id = CatalystId.fromUri(Uri.parse(rawUri));

      const expectedUsername = 'damian m';

      // When
      final username = id.username;

      // Then
      expect(username, expectedUsername);
    });

    test('username with spaces is encoded correctly', () {
      const username = 'damian m';
      final id = CatalystId(
        host: CatalystIdHost.cardano.host,
        role0Key: role0Key,
        username: 'damian m',
      );

      final encodedUsername = Uri.encodeComponent(username);

      // When
      final uri = id.toUri();
      final userInfo = uri.userInfo;

      // Then
      expect(userInfo, contains(encodedUsername));
    });
  });
}

/* cSpell:enable */
