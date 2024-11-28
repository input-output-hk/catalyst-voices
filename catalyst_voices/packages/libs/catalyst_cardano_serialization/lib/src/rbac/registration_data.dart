import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Defines the X509 Role Based Access Control transaction metadata.
final class RegistrationData extends Equatable implements CborEncodable {
  /// Un-ordered List of DER encoded x509 certificates.
  final List<X509DerCertificate>? derCerts;

  /// Un-ordered List of CBOR encoded C509 certificates
  /// (or metadatum references).
  //
  // TODO(dtscalac): support C509CertInMetadatumReference
  final List<C509Certificate>? cborCerts;

  /// Ordered list of simple public keys that are registered.
  final List<Ed25519PublicKey>? publicKeys;

  /// Revocation list of certs being revoked by an issuer.
  final List<CertificateHash>? revocationSet;

  /// Set of role registration data.
  final Set<RoleData>? roleDataSet;

  /// The default constructor for [RegistrationData].
  const RegistrationData({
    this.derCerts,
    this.cborCerts,
    this.publicKeys,
    this.revocationSet,
    this.roleDataSet,
  });

  /// Deserializes the type from cbor.
  factory RegistrationData.fromCbor(CborValue value) {
    final map = value as CborMap;
    final derCerts = map[const CborSmallInt(10)] as CborList?;
    final cborCerts = map[const CborSmallInt(20)] as CborList?;
    final publicKeys = map[const CborSmallInt(30)] as CborList?;
    final revocationSet = map[const CborSmallInt(40)] as CborList?;
    final roleDataSet = map[const CborSmallInt(100)] as CborList?;

    return RegistrationData(
      derCerts: derCerts?.map(X509DerCertificate.fromCbor).toList(),
      cborCerts: cborCerts?.map(C509Certificate.fromCbor).toList(),
      publicKeys: publicKeys?.map(Ed25519PublicKey.fromCbor).toList(),
      revocationSet: revocationSet?.map(CertificateHash.fromCbor).toList(),
      roleDataSet: roleDataSet?.map(RoleData.fromCbor).toSet(),
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() => CborMap(_buildCborMap());

  /// Builds a CborMap from the class properties.
  Map<CborSmallInt, CborValue> _buildCborMap() {
    final entries = <CborSmallInt, CborValue?>{
      const CborSmallInt(10): _createCborList<X509DerCertificate>(
        derCerts,
        (item) => item.toCbor(),
      ),
      const CborSmallInt(20): _createCborList<C509Certificate>(
        cborCerts,
        (item) => item.toCbor(),
      ),
      const CborSmallInt(30): _createCborList<Ed25519PublicKey>(
        publicKeys,
        (item) => item.toCbor(tags: [CborCustomTags.ed25519Bip32PublicKey]),
      ),
      const CborSmallInt(40): _createCborList<CertificateHash>(
        revocationSet,
        (item) => item.toCbor(),
      ),
      const CborSmallInt(100): _createCborList<RoleData>(
        roleDataSet?.toList(),
        (item) => item.toCbor(),
      ),
    }..removeWhere((key, value) => value == null);

    return entries.cast();
  }

  CborList? _createCborList<T>(List<T>? items, CborValue Function(T) toCbor) {
    if (items == null || items.isEmpty) return null;
    return CborList(items.map(toCbor).toList());
  }

  @override
  List<Object?> get props =>
      [derCerts, cborCerts, publicKeys, revocationSet, roleDataSet];
}

/// Roles are defined in a list.
/// A user can register for any available role, and they can enrol in more
/// than one role in a single registration transaction.
///
/// The validity of the registration is as per the rules for roles defined
/// by the dApp itself.
class RoleData extends Equatable implements CborEncodable {
  /// All roles, except for Role 0, are defined by the dApp.
  ///
  /// Role 0 is the primary role and is used to sign the metadata and declare on-chain/off-chain identity linkage.
  /// All compliant implementations of this specification use Role 0
  /// in this way.
  ///
  /// dApps can extend what other use cases Role 0 has, but it will always
  /// be used to secure the Role registrations.
  ///
  /// For example, in Catalyst Role 0 is a basic voters role.
  /// Voters do not need to register for any other role to have basic
  /// interaction with project Catalyst.
  ///
  /// The recommendation is that Role 0 be used by dApps to give the minimum
  /// level of access the dApp requires and other extended roles are defined
  /// as Role 1+.
  final int roleNumber;

  /// Each role can optionally be used to sign data.
  /// If the role is intended to sign data, the key it uses to sign must be
  /// declared in this field.
  /// This is a reference to either a registered certificate for the identity
  /// posting the registration, or one of the defined simple public keys.
  ///
  /// A dApp can define is roles allow the use of certificates, or simple
  /// public keys, or both.
  ///
  /// Role 0 MUST have a signing key, and it must be a certificate.
  /// Simple keys can not be used for signing against Role 0.
  ///
  /// The reason for this is the Role 0 certificate MUST include a reference
  /// to the on-chain identity/s to be bound to the registration.
  /// Simple public keys can not contain this reference, which is why they are
  /// not permissible for Role 0 keys.
  ///
  /// A reference to a key/certificate can be a cert in the same registration,
  /// or any previous registration.
  ///
  /// If the certificate is revoked, the role is unusable for signing unless
  /// and until a new signing certificate is registered for the role.
  final LocalKeyReference? roleSigningKey;

  /// A Role may require the ability to transfer encrypted data.
  /// The registration can include the Public key use by the role to encrypt
  /// the roles data.
  /// Due to the way public key encryption works, this key can only be used to
  /// send encrypted data to the holder of the public key.
  /// However, when two users have registered public keys,
  /// they can use them off-chain to perform key exchange and communicate
  /// privately between themselves.
  ///
  /// The Role encryption key must be a reference to a key that supports public
  /// key encryption, and not just a signing key.
  /// If the key referenced does not support public key encryption,
  /// the registration is invalid.
  final LocalKeyReference? roleEncryptionKey;

  /// Reference to a transaction input/output as the payment key to use for a role.
  /// Payment key (n) >= 0 = Use Transaction Input Key offset (n)
  /// as the payment key.
  /// Payment key (n) < 0 = Use Transaction Output Key offset -(n+1)
  /// as the payment key.
  ///
  /// If a transaction output payment key is defined the payment address must
  /// also be in the required_signers of the transaction to ensure the payment
  /// address is owned and controlled by the entity posting the registration.
  ///
  /// If the referenced payment key does not exist in the transaction,
  /// or is not witnessed the entire registration is to be considered invalid.
  final int? paymentKey;

  /// Each dApp can declare that roles can have either mandatory or optional
  /// data items that can be posted with any role registration.
  ///
  /// Each role can have a different set of defined role registration data.
  /// It is not required that all roles have the same data.
  ///
  /// As the role data is dApp specific, it is not detailed here.
  /// Each dApp will need to produce a specification of what role specific data
  /// it requires, and how it is validated.
  final Map<int, CborValue>? roleSpecificData;

  /// The default constructor for [RoleData].
  const RoleData({
    required this.roleNumber,
    this.roleSigningKey,
    this.roleEncryptionKey,
    this.paymentKey,
    this.roleSpecificData,
  });

  /// Deserializes the type from cbor.
  factory RoleData.fromCbor(CborValue value) {
    final map = value as CborMap;

    final roleNumber = map[const CborSmallInt(0)]! as CborSmallInt;
    final roleSigningKey = map[const CborSmallInt(1)];
    final roleEncryptionKey = map[const CborSmallInt(2)];
    final paymentKey = map[const CborSmallInt(3)] as CborSmallInt?;
    final roleSpecificData = Map.of(map)
      ..remove(const CborSmallInt(0))
      ..remove(const CborSmallInt(1))
      ..remove(const CborSmallInt(2))
      ..remove(const CborSmallInt(3));

    return RoleData(
      roleNumber: roleNumber.value,
      roleSigningKey: roleSigningKey != null
          ? LocalKeyReference.fromCbor(roleSigningKey)
          : null,
      roleEncryptionKey: roleEncryptionKey != null
          ? LocalKeyReference.fromCbor(roleEncryptionKey)
          : null,
      paymentKey: paymentKey?.value,
      roleSpecificData: roleSpecificData.isNotEmpty
          ? roleSpecificData
              .map((key, value) => MapEntry((key as CborSmallInt).value, value))
          : null,
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap({
      const CborSmallInt(0): CborSmallInt(roleNumber),
      if (roleSigningKey != null)
        const CborSmallInt(1): roleSigningKey!.toCbor(),
      if (roleEncryptionKey != null)
        const CborSmallInt(2): roleEncryptionKey!.toCbor(),
      if (paymentKey != null) const CborSmallInt(3): CborSmallInt(paymentKey!),
      if (roleSpecificData != null)
        for (final entry in roleSpecificData!.entries)
          CborSmallInt(entry.key): entry.value,
    });
  }

  @override
  List<Object?> get props => [
        roleNumber,
        roleSigningKey,
        roleEncryptionKey,
        paymentKey,
        roleSpecificData,
      ];
}

/// Offset reference to a key defined in this registration.
///
/// More efficient than a key hash.
class LocalKeyReference extends Equatable implements CborEncodable {
  /// A type of referenced key.
  final LocalKeyReferenceType keyType;

  /// Offset of the key in the specified set. 0 = first entry.
  final int offset;

  /// The default constructor for [LocalKeyReference].
  const LocalKeyReference({
    required this.keyType,
    required this.offset,
  });

  /// Deserializes the type from cbor.
  factory LocalKeyReference.fromCbor(CborValue value) {
    final list = value as CborList;
    final keyType = list[0] as CborSmallInt;
    final offset = list[1] as CborSmallInt;

    return LocalKeyReference(
      keyType: LocalKeyReferenceType.fromTag(keyType.value),
      offset: offset.value,
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborList([
      CborSmallInt(keyType.tag),
      CborSmallInt(offset),
    ]);
  }

  @override
  List<Object?> get props => [keyType, offset];
}

/// Defines the type of the referenced local key.
enum LocalKeyReferenceType {
  /// The DER encoded X509 certificate.
  x509Certs(tag: 10),

  /// The C509 encoded certificate.
  c509Certs(tag: 20),

  /// The public key.
  pubKeys(tag: 30);

  /// The magic number defining the certificate type.
  final int tag;

  /// The default constructor for [LocalKeyReferenceType].
  const LocalKeyReferenceType({required this.tag});

  /// Returns a [LocalKeyReferenceType] by a [tag].
  factory LocalKeyReferenceType.fromTag(int tag) {
    for (final value in values) {
      if (value.tag == tag) return value;
    }

    throw ArgumentError('Undefined LocalKeyReferenceType with tag: $tag');
  }
}
