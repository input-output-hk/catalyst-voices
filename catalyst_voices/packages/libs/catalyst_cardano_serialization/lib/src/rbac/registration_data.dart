import 'package:catalyst_cardano_serialization/src/certificate.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/rbac/rbac_field.dart';
import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [keyType, offset];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborList(
      [
        CborSmallInt(keyType.tag),
        CborSmallInt(offset),
      ],
      tags: tags,
    );
  }
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

/// Defines the X509 Role Based Access Control transaction metadata.
final class RegistrationData extends Equatable implements CborEncodable {
  /// Un-ordered List of DER encoded x509 certificates.
  final List<RbacField<X509DerCertificate>>? derCerts;

  /// Un-ordered List of CBOR encoded C509 certificates.
  //
  // The metadatum references to certs (`C509CertInMetadatumReference`) are not supported,
  // they were not needed for the initial implementation for the RBAC registration.
  final List<RbacField<C509Certificate>>? cborCerts;

  /// Ordered list of simple public keys that are registered.
  final List<RbacField<Ed25519PublicKey>>? publicKeys;

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
      derCerts: _parseRbacFieldCborList(derCerts, X509DerCertificate.fromCbor),
      cborCerts: _parseRbacFieldCborList(cborCerts, C509Certificate.fromCbor),
      publicKeys: _parseRbacFieldCborList(publicKeys, Ed25519PublicKey.fromCbor),
      revocationSet: revocationSet?.map(CertificateHash.fromCbor).toList(),
      roleDataSet: roleDataSet?.map(RoleData.fromCbor).toSet(),
    );
  }

  @override
  List<Object?> get props => [derCerts, cborCerts, publicKeys, revocationSet, roleDataSet];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) => CborMap(
    _buildCborMap(),
    tags: tags,
  );

  /// Builds a CborMap from the class properties.
  Map<CborSmallInt, CborValue> _buildCborMap() {
    final entries = <CborSmallInt, CborValue?>{
      const CborSmallInt(10): _createCborList(derCerts),
      const CborSmallInt(20): _createCborList(cborCerts),
      const CborSmallInt(30): _createCborList(
        publicKeys,
        mapper: (item) => item.toCbor(
          tags: [CborCustomTags.ed25519Bip32PublicKey],
        ),
      ),
      const CborSmallInt(40): _createCborList(revocationSet),
      const CborSmallInt(100): _createCborList(roleDataSet?.toList()),
    }..removeWhere((key, value) => value == null);

    return entries.cast();
  }

  CborList? _createCborList<T extends CborEncodable>(
    List<T>? items, {
    CborValue Function(T item)? mapper,
  }) {
    if (items == null || items.isEmpty) return null;
    return CborList(
      items.map((e) => mapper != null ? mapper(e) : e.toCbor()).toList(),
    );
  }

  static List<RbacField<T>>? _parseRbacFieldCborList<T extends CborEncodable>(
    CborList? list,
    T Function(CborValue) fromCbor,
  ) {
    return list
        ?.map(
          (item) => RbacField.fromCbor(item, fromCbor: fromCbor),
        )
        .toList();
  }
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

  /// A Payment key reference in this CIP solves this problem by only allowing a reference
  /// to transaction output. The reference is a simple unsigned integer.
  /// The integer represent the index of the transaction outputs. For example,
  /// integer 0 refers to index 0 of the transaction outputs.
  ///
  /// For the payment key to be validated, it must be witnessed in the transaction,
  /// this can be achieved by either:
  ///
  /// - Using the same payment key from an input to the transaction as an output.
  ///
  /// - If the payment key is not an input to the transaction, including it in the
  ///   Required Signers field of the transaction. Payment keys which are not witnessed are invalid,
  ///   as they can not be proven to both be:
  ///
  ///   - Owned and controlled by the wallet signing the transaction and posting the registration.
  ///   - Spendable. Ensuring this validity reduces the risk of invalid payments,
  ///     or paying the wrong individuals, and eliminates the need to make "trial" payments
  ///     to validate an address is payable.
  ///
  /// If the transaction output address IS also an input to the transaction,
  /// then the same proof has already been attached to the transaction.
  /// However, if the transaction output is not also an input, the transaction MUST include
  /// the output address in the required signers field, and the transaction must carry a witness
  /// proving the payment key is owned.
  ///
  /// This provides guarantees that the entity posting the registration has posted
  /// a valid payment address, and that they control it. If a payment address is not able
  /// to be validated, then the entire registration metadata is invalid.
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
      roleSigningKey: roleSigningKey != null ? LocalKeyReference.fromCbor(roleSigningKey) : null,
      roleEncryptionKey: roleEncryptionKey != null
          ? LocalKeyReference.fromCbor(roleEncryptionKey)
          : null,
      paymentKey: paymentKey?.value,
      roleSpecificData: roleSpecificData.isNotEmpty
          ? roleSpecificData.map((key, value) => MapEntry((key as CborSmallInt).value, value))
          : null,
    );
  }

  @override
  List<Object?> get props => [
    roleNumber,
    roleSigningKey,
    roleEncryptionKey,
    paymentKey,
    roleSpecificData,
  ];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborMap(
      {
        const CborSmallInt(0): CborSmallInt(roleNumber),
        if (roleSigningKey != null) const CborSmallInt(1): roleSigningKey!.toCbor(),
        if (roleEncryptionKey != null) const CborSmallInt(2): roleEncryptionKey!.toCbor(),
        if (paymentKey != null) const CborSmallInt(3): CborSmallInt(paymentKey!),
        if (roleSpecificData != null)
          for (final entry in roleSpecificData!.entries) CborSmallInt(entry.key): entry.value,
      },
      tags: tags,
    );
  }
}
