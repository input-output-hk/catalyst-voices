import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' hide Ed25519PublicKey;
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(X509Certificate, () {
    final signature = FakeBip32Ed25519XSignature([4, 5, 6]);
    final privateKey = FakeBip32Ed25519XPrivateKey([], customSignature: signature);
    final publicKey = Ed25519PublicKey.seeded(0);

    setUpAll(() {
      Bip32Ed25519XPublicKeyFactory.instance = FakeBip32Ed25519XPublicKeyFactory();
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
      expect(decodedCertificate, equals(decodedCertificate));
    });
  });
}
