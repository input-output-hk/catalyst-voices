import 'package:catalyst_cardano_serialization/src/rbac/x509_certificate.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group(X509Certificate, () {
    final signature = _FakeBip32Ed25519XSignature();
    final privateKey = _FakeBip32Ed25519XPrivateKey(signature: signature);
    final publicKey = _FakeBip32Ed25519XPublicKey();

    setUpAll(() {
      Bip32Ed25519XPublicKeyFactory.instance =
          _FakeBip32Ed25519XPublicKeyFactory();
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
      validityNotBefore: DateTime.now().toUtc(),
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
      expect(decodedCertificate, equals(decodedCertificate));
    });
  });
}

class _FakeBip32Ed25519XPrivateKey extends Fake
    implements Bip32Ed25519XPrivateKey {
  final Bip32Ed25519XSignature signature;

  _FakeBip32Ed25519XPrivateKey({required this.signature});

  @override
  Future<Bip32Ed25519XSignature> sign(List<int> message) async {
    return signature;
  }
}

class _FakeBip32Ed25519XPublicKey extends Fake
    implements Bip32Ed25519XPublicKey {
  @override
  List<int> get bytes => [1, 2, 3];
}

class _FakeBip32Ed25519XPublicKeyFactory extends Fake
    implements Bip32Ed25519XPublicKeyFactory {
  @override
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XPublicKey();
  }
}

class _FakeBip32Ed25519XSignature extends Fake
    implements Bip32Ed25519XSignature {
  @override
  List<int> get bytes => [4, 5, 6];
}
