import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

/* cSpell:disable */
void main() {
  group(CatalystId, () {
    late Uint8List role0Key;

    setUpAll(() {
      role0Key = base64UrlNoPadDecode('FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE');
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

    test('should create minimal $CatalystId instance with username correctly', () {
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

    test('should parse minimal $CatalystId with username from Uri correctly', () {
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
      expect(idOne.isSameAs(idTwo), isTrue);
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
      expect(idOne.isSameAs(idTwo), isFalse);
    });

    test('username with spaces is decoded correctly', () {
      const rawUri =
          'id.catalyst://'
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

    test('should fail at parsing', () {
      const validUri = 'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=';

      const invalidUri = 'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDs=';
      const invalidUri2 = '';

      final validCatalystId = CatalystId.tryParse(validUri);
      expect(validCatalystId?.host, equals(CatalystIdHost.cardano.host));
      expect(validCatalystId?.username, isNull);
      expect(validCatalystId?.nonce, isNull);
      expect(validCatalystId?.role0Key, isNotNull);
      expect(validCatalystId?.role?.number, isNull);
      expect(validCatalystId?.rotation, isNull);
      expect(validCatalystId?.encrypt, isFalse);

      final invalidCatalystId = CatalystId.tryParse(invalidUri);
      final invalidCatalystId2 = CatalystId.tryParse(invalidUri2);

      expect(invalidCatalystId, isNull);
      expect(invalidCatalystId2, isNull);
    });

    group('uid', () {
      test('returns correctly formatted string', () {
        const host = CatalystIdHost.cardano;
        final id = CatalystId(
          // ignore: avoid_redundant_argument_values
          scheme: CatalystId.idScheme,
          host: host.host,
          role0Key: role0Key,
        );

        // Expected format: scheme://host/encodedKey
        final expected = '${CatalystId.idScheme}://${host.host}/${base64UrlNoPadEncode(role0Key)}';
        expect(id.uid, expected);
      });

      test('remains same when non-identity fields differ', () {
        final baseId = CatalystId(
          host: CatalystIdHost.cardano.host,
          role0Key: role0Key,
          username: 'alice',
          nonce: 123456,
          // ignore: avoid_redundant_argument_values
          encrypt: false,
        );

        final modifiedId = baseId.copyWith(
          username: const Optional('bob'),
          nonce: const Optional(999999),
          encrypt: true,
          role: const Optional(AccountRole.drep),
        );

        // The significant parts (host, scheme, key) haven't changed,
        // so the UID must be identical.
        expect(baseId.uid, equals(modifiedId.uid));
      });

      test('consistency with isSameAs', () {
        // If two IDs are "the same", their UIDs must match.
        final id1 = CatalystId(host: 'cardano', role0Key: role0Key, username: 'user1');

        final id2 = CatalystId(host: 'cardano', role0Key: role0Key, username: 'user2');

        expect(id1.isSameAs(id2), isTrue);
        expect(id1.uid, equals(id2.uid));
      });

      test('can be parsed base into same CatalystId', () {
        final catId = CatalystId(
          host: CatalystIdHost.cardano.host,
          role0Key: role0Key,
          username: 'alice',
          nonce: 123456,
          // ignore: avoid_redundant_argument_values
          encrypt: false,
        );

        final decodedCatId = CatalystId.parse(catId.uid);

        expect(decodedCatId.isSameAs(catId), isTrue);
      });
    });
  });
}

/* cSpell:enable */
