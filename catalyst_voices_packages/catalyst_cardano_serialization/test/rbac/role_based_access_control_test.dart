import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/certificate.dart';
import 'package:catalyst_cardano_serialization/src/rbac/role_based_access_control.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

import '../test_utils/test_data.dart';

void main() {
  group(RbacMetadata, () {
    test('from and to cbor', () {
      final derCert = X509DerCertificate.fromHex(derCertHex);
      final c509Cert = C509Certificate.fromHex(c509CertHex);

      final original = RbacMetadata(
        derCerts: [derCert],
        cborCerts: [c509Cert],
        publicKeys: [Ed25519PublicKey.seeded(0)],
        revocationSet: [
          CertificateHash.fromX509DerCertificate(derCert),
          CertificateHash.fromC509Certificate(c509Cert),
        ],
        roleDataSet: {
          RoleData(
            roleNumber: 0,
            roleSigningKey: KeyReference(
              localRef: const LocalKeyReference(
                keyType: LocalKeyReferenceType.x509Certs,
                keyOffset: 0,
              ),
            ),
            roleEncryptionKey: KeyReference(
              hash: CertificateHash.fromX509DerCertificate(derCert),
            ),
            paymentKey: 0,
            roleSpecificData: {
              10: CborString('Test'),
            },
          ),
        },
      );

      final encoded = original.toCbor();
      final decoded = RbacMetadata.fromCbor(encoded);
      expect(original, equals(decoded));
    });
  });
}
