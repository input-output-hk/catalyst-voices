import 'package:catalyst_cardano_serialization/src/rbac/x509_certificate.dart';
import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:test/test.dart';

void main() {
  group(X509Certificate, () {
    test('generateSelfSigned X509 certificate', () async {
      final seed = List.filled(Ed25519PrivateKey.length, 0);
      final keyPair = await Ed25519KeyPair.fromSeed(seed);

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
        subjectPublicKey: keyPair.publicKey,
        issuer: issuer,
        validityNotBefore: DateTime.now().toUtc(),
        validityNotAfter: X509TBSCertificate.foreverValid,
        subject: issuer,
        extensions: const X509CertificateExtensions(
          subjectAltName: [
            'mydomain.com',
            'www.mydomain.com',
            'example.com',
            'www.example.com',
          ],
        ),
      );
      /* cSpell:enable */

      final certificate = await X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        keyPair: keyPair,
      );

      expect(certificate.tbsCertificate, equals(tbs));
      expect(certificate.signature, isNotEmpty);

      expect(certificate.toPem(), isNotEmpty);
      expect(certificate.toDer().bytes, isNotEmpty);
    });
  });
}
