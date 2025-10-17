import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart'
    as kd hide Ed25519PublicKey;
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart' as test;

void main() {
  test.group(X509Certificate, () {
    final signature = FakeBip32Ed25519XSignature([4, 5, 6]);
    final privateKey = _FakeBip32Ed25519XPrivateKey(signature: signature);
    final publicKey = Ed25519PublicKey.seeded(0);

    test.setUpAll(() {
      kd.Bip32Ed25519XPublicKeyFactory.instance = FakeBip32Ed25519XPublicKeyFactory();
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

    test.test('generateSelfSigned X509 certificate', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      test.expect(certificate.tbsCertificate, test.equals(tbs));
      test.expect(certificate.signature, test.equals(signature.bytes));

      test.expect(certificate.toPem(), test.isNotEmpty);
      test.expect(certificate.toDer().bytes, test.isNotEmpty);
    });

    test.test('generateSelfSigned and re-encode', () async {
      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );

      final derCertificate = certificate.toDer();
      final decodedCertificate = X509Certificate.fromDer(derCertificate);
      test.expect(decodedCertificate, test.equals(decodedCertificate));
    });
  });
}

// Custom fake for this specific test that returns a specific signature
class _FakeBip32Ed25519XPrivateKey extends Fake
    implements kd.Bip32Ed25519XPrivateKey {
  final kd.Bip32Ed25519XSignature signature;

  _FakeBip32Ed25519XPrivateKey({required this.signature});

  @override
  Future<kd.Bip32Ed25519XSignature> sign(List<int> message) async {
    return signature;
  }
}
