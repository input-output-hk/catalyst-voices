import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_registration_chain.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_role_data.dart';
import 'package:collection/collection.dart';

/// DTO utils for [RbacRegistrationChain], mostly helpers to decode **complex**
/// data types that can't just be json deserialized.
extension RbacRegistrationChainExt on RbacRegistrationChain {
  Set<AccountRole> get accountRoles {
    final accountRoles = _roles
        .map((role) => AccountRole.maybeFromNumber(role.roleId))
        .nonNulls
        .toSet();

    return accountRoles;
  }

  ShelleyAddress get stakeAddress {
    final signingKeys = _rootRoleData.signingKeys;
    final signingKey = signingKeys.firstOrNull;
    if (signingKey == null) {
      throw ArgumentError.notNull('signingKey');
    }

    final signingKeyType = signingKey.keyType;

    if (signingKeyType != RegistrationCertificate.certificateType) {
      throw ArgumentError.value(
        signingKeyType,
        'signingKeyType',
        'Was not a ${RegistrationCertificate.certificateType} key.',
      );
    }

    final signingKeyValue = signingKey.keyValue?.x509;

    if (signingKeyValue == null) {
      throw ArgumentError.value(
        signingKeyValue,
        'signingKeyValue',
        'Was null for $signingKeyType key (the value was deleted or key type mismatch).',
      );
    }

    final x509Certificate = X509Certificate.fromPem(signingKeyValue);
    return _decodeStakeAddressFromCertificate(x509Certificate);
  }

  List<RbacRoleData> get _roles {
    final hasRootRole = roles.any((role) => role.roleId == _rootRoleKey);
    if (!hasRootRole) {
      throw ArgumentError.value(
        roles,
        'roles',
        'Did not contain mandatory root role.',
      );
    }

    return roles;
  }

  /// The root role data. If missing [ArgumentError] is thrown.
  RbacRoleData get _rootRoleData => _roles.firstWhere((role) => role.roleId == _rootRoleKey);

  int get _rootRoleKey => AccountRole.root.number;

  ShelleyAddress _decodeStakeAddressFromCertificate(
    X509Certificate certificate,
  ) {
    final extensions = certificate.tbsCertificate.extensions;
    if (extensions == null) {
      throw ArgumentError.notNull('extensions');
    }

    final subjectAltName = extensions.subjectAltName;
    if (subjectAltName == null) {
      throw ArgumentError.notNull('subjectAltName');
    }

    final stakeAddressUri = subjectAltName
        .map((e) => e.value)
        .firstWhereOrNull(CardanoAddressUri.isCardanoAddressUri);

    if (stakeAddressUri == null) {
      throw ArgumentError.notNull('stakeAddressUri');
    }

    return CardanoAddressUri.fromString(stakeAddressUri).address;
  }
}
