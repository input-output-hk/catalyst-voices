import 'package:catalyst_cardano_serialization/src/rbac/x509_certificate.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'x509_certificate_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Bip32Ed25519XPrivateKey>(),
  MockSpec<Bip32Ed25519XPublicKey>(),
  MockSpec<Bip32Ed25519XSignature>(),
])
void main() {
  group(X509Certificate, () {
    final privateKey = MockBip32Ed25519XPrivateKey();
    final publicKey = MockBip32Ed25519XPublicKey();
    final signature = MockBip32Ed25519XSignature();

    setUp(() {
      // ignore: discarded_futures
      when(privateKey.sign(any)).thenAnswer((_) async => signature);
      when(signature.bytes).thenReturn([1, 2, 3]);
    });

    test('generateSelfSigned X509 certificate', () async {
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
        privateKey: privateKey,
      );

      expect(certificate.tbsCertificate, equals(tbs));
      expect(certificate.signature, equals(signature.bytes));

      expect(certificate.toPem(), isNotEmpty);
      expect(certificate.toDer().bytes, isNotEmpty);
    });
  });
}
