import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' hide Ed25519PublicKey;
import 'package:collection/collection.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(X509Certificate, () {
    final signature = _FakeBip32Ed25519XSignature();
    final privateKey = _FakeBip32Ed25519XPrivateKey(signature: signature);
    final publicKey = Ed25519PublicKey.seeded(0);

    setUpAll(() {
      Bip32Ed25519XPublicKeyFactory.instance = _FakeBip32Ed25519XPublicKeyFactory();
    });

    /* cSpell:disable */
    const issuer = X509DistinguishedName(
      countryName: 'US',
      stateOrProvinceName: 'California',
      localityName: 'San Francisco',
      organizationName: 'MyCompany',
      organizationalUnitName: 'MyDepartment',
      commonName: 'mydomain.com',
    );

    final tbs = X509TBSCertificate(
      serialNumber: 1,
      subjectPublicKey: publicKey,
      issuer: issuer,
      validityNotBefore: DateTime.utc(2025, 3, 1, 12),
      validityNotAfter: X509TBSCertificate.foreverValid,
      subject: issuer,
      extensions: const X509CertificateExtensions(
        subjectAltName: [
          X509String('mydomain.com', tag: X509String.domainNameTag),
          X509String('www.mydomain.com', tag: X509String.domainNameTag),
          X509String('example.com', tag: X509String.domainNameTag),
          X509String('www.example.com', tag: X509String.domainNameTag),
        ],
      ),
    );
    /* cSpell:enable */

    test('generateSelfSigned X509 certificate', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      expect(certificate.tbsCertificate, equals(tbs));
      expect(certificate.signature, equals(signature.bytes));

      expect(certificate.toPem(), isNotEmpty);
      expect(certificate.toDer().bytes, isNotEmpty);
    });

    test('generateSelfSigned and re-encode', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      final derCertificate = certificate.toDer();
      final decodedCertificate = X509Certificate.fromDer(derCertificate);
      expect(decodedCertificate, equals(certificate));
    });

    test('fromPem decodes PEM certificate correctly', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      final pem = certificate.toPem();
      final decodedCertificate = X509Certificate.fromPem(pem);

      expect(decodedCertificate, equals(certificate));
    });

    test('fromPem handles custom label', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      final pem = certificate.toPem('CUSTOM LABEL');
      final decodedCertificate = X509Certificate.fromPem(pem);

      expect(decodedCertificate, equals(certificate));
    });

    test('fromPem handles whitespace variations', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      final normalPem = certificate.toPem();
      final pemWithWhitespace = normalPem.replaceAll('\n', '\n\t  ');
      final decodedCertificate = X509Certificate.fromPem(pemWithWhitespace);

      expect(decodedCertificate, equals(certificate));
    });

    test('extractBase64FromPem removes header and footer', () {
      /* cSpell:disable */
      const pem = '''
-----BEGIN CERTIFICATE-----
MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE
-----END CERTIFICATE-----
''';

      final base64 = X509Certificate.extractBase64FromPem(pem);

      expect(base64, isNot(contains('-----BEGIN')));
      expect(base64, isNot(contains('-----END')));
      expect(base64, isNot(contains('CERTIFICATE')));
      expect(base64, isNot(contains('\n')));
      expect(base64, isNot(contains(' ')));
      expect(base64, equals('MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE'));
      /* cSpell:enable */
    });

    test('extractBase64FromPem handles custom label', () {
      /* cSpell:disable */
      const pem = '''
-----BEGIN CUSTOM LABEL-----
MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE
-----END CUSTOM LABEL-----
''';

      final base64 = X509Certificate.extractBase64FromPem(pem);

      expect(base64, equals('MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE'));
      /* cSpell:enable */
    });

    test('extractBase64FromPem handles label without spaces', () {
      /* cSpell:disable */
      const pem = '''
-----BEGIN-----
MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE
-----END-----
''';

      final base64 = X509Certificate.extractBase64FromPem(pem);

      expect(base64, equals('MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE'));
      /* cSpell:enable */
    });

    test('extractBase64FromPem removes all whitespace types', () {
      /* cSpell:disable */
      const pem = '''
-----BEGIN CERTIFICATE-----
MIIB /DCC Aa6g
AwIB  AgIF\tAI0A
-----END CERTIFICATE-----
''';

      final base64 = X509Certificate.extractBase64FromPem(pem);

      expect(base64, equals('MIIB/DCCAa6gAwIBAgIFAI0A'));
      expect(base64, isNot(contains(' ')));
      expect(base64, isNot(contains('\t')));
      expect(base64, isNot(contains('\n')));
      /* cSpell:enable */
    });

    test('extractBase64FromPem handles multiple newlines', () {
      /* cSpell:disable */
      const pem = '''
-----BEGIN CERTIFICATE-----


MIIB/DCCAa6g


AwIBAgIFAI0A
zRIwBQYDK2Vw
MEIxCTAHBgNV
BAYTADEJMAcG

A1UE

-----END CERTIFICATE-----
''';

      final base64 = X509Certificate.extractBase64FromPem(pem);

      expect(base64, equals('MIIB/DCCAa6gAwIBAgIFAI0AzRIwBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE'));
      /* cSpell:enable */
    });
  });
}

class _FakeBip32Ed25519XPrivateKey extends Fake implements Bip32Ed25519XPrivateKey {
  final Bip32Ed25519XSignature signature;

  _FakeBip32Ed25519XPrivateKey({required this.signature});

  @override
  Future<Bip32Ed25519XSignature> sign(List<int> message) async {
    return signature;
  }
}

class _FakeBip32Ed25519XPublicKey extends Fake implements Bip32Ed25519XPublicKey {
  @override
  List<int> get bytes => [1, 2, 3];

  @override
  int get hashCode => bytes.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Bip32Ed25519XPublicKey &&
        const DeepCollectionEquality().equals(bytes, other.bytes);
  }
}

class _FakeBip32Ed25519XPublicKeyFactory extends Fake implements Bip32Ed25519XPublicKeyFactory {
  @override
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XPublicKey();
  }
}

class _FakeBip32Ed25519XSignature extends Fake implements Bip32Ed25519XSignature {
  @override
  List<int> get bytes => [4, 5, 6];
}
