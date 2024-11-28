import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_utils/test_data.dart';

void main() {
  group(RegistrationData, () {
    setUpAll(() {
      Bip32Ed25519XPrivateKeyFactory.instance =
          _FakeBip32Ed25519XPrivateKeyFactory();

      Bip32Ed25519XPublicKeyFactory.instance =
          _FakeBip32Ed25519XPublicKeyFactory();
    });

    test('from and to cbor', () {
      final derCert = X509DerCertificate.fromHex(derCertHex);
      final c509Cert = C509Certificate.fromHex(c509CertHex);

      final original = RegistrationData(
        derCerts: [derCert],
        cborCerts: [c509Cert],
        publicKeys: [Bip32Ed25519XPublicKeyFactory.instance.seeded(0)],
        revocationSet: [
          CertificateHash.fromX509DerCertificate(derCert),
          CertificateHash.fromC509Certificate(c509Cert),
        ],
        roleDataSet: {
          RoleData(
            roleNumber: 0,
            roleSigningKey: const LocalKeyReference(
              keyType: LocalKeyReferenceType.x509Certs,
              offset: 0,
            ),
            roleEncryptionKey: const LocalKeyReference(
              keyType: LocalKeyReferenceType.x509Certs,
              offset: 0,
            ),
            paymentKey: 0,
            roleSpecificData: {
              10: CborString('Test'),
            },
          ),
        },
      );

      final encoded = original.toCbor();
      final decoded = RegistrationData.fromCbor(encoded);
      expect(original, equals(decoded));
    });
  });
}

class _FakeBip32Ed25519XPrivateKeyFactory
    extends Bip32Ed25519XPrivateKeyFactory {
  @override
  Bip32Ed25519XPrivateKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed22519XPrivateKey(bytes: bytes);
  }
}

class _FakeBip32Ed25519XPublicKeyFactory extends Bip32Ed25519XPublicKeyFactory {
  @override
  _FakeBip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XPublicKey(bytes: bytes);
  }
}

class _FakeBip32Ed22519XPrivateKey extends Fake
    implements Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed22519XPrivateKey({required this.bytes});

  @override
  CborValue toCbor() {
    return CborBytes(bytes);
  }
}

class _FakeBip32Ed25519XPublicKey extends Fake
    with EquatableMixin
    implements Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPublicKey({required this.bytes});

  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborBytes(bytes, tags: tags);
  }

  @override
  List<Object?> get props => bytes;
}
