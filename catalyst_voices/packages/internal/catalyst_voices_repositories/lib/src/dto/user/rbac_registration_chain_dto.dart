import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';

/// DTO utils for [RbacRegistrationChain], mostly helpers to decode **complex**
/// data types that can't just be json deserialized.
extension RbacRegistrationChainExt on RbacRegistrationChain {
  Set<AccountRole> get accountRoles {
    final roleNumbers = _roleData.keys.map(int.tryParse);
    final accountRoles =
        roleNumbers.map(AccountRole.maybeFromNumber).nonNulls.toSet();

    return accountRoles;
  }

  ShelleyAddress get stakeAddress {
    final rootRoleData = _roleData[_rootRoleKey] as Map<String, dynamic>;
    final signingKeys = rootRoleData['signing_keys'] as List<dynamic>;
    final signingKey = signingKeys.firstOrNull as Map<String, dynamic>?;
    if (signingKey == null) {
      throw ArgumentError.notNull('signingKey');
    }

    final signingKeyType = signingKey['key_type'] as String;
    final signingKeyValue = signingKey['key_value'] as String;

    if (signingKeyType != RegistrationCertificate.certificateType) {
      throw ArgumentError.value(
        signingKeyType,
        'signingKeyType',
        'Was not a ${RegistrationCertificate.certificateType} key.',
      );
    }

    final x509Certificate = _decodeX509Certificate(signingKeyValue);
    return _decodeStakeAddressFromCertificate(x509Certificate);
  }

  Map<String, dynamic> get _roleData {
    final roleData = roles as Map<String, dynamic>;
    if (!roleData.containsKey(_rootRoleKey)) {
      throw ArgumentError.value(
        roleData,
        'roleData',
        'Did not contain mandatory root role.',
      );
    }

    return roleData;
  }

  String get _rootRoleKey => AccountRole.root.number.toString();

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

  X509Certificate _decodeX509Certificate(String hexString) {
    final certificateBytes = hex.decode(hexString.replaceFirst('0x', ''));
    final derCertificate =
        X509DerCertificate.fromBytes(bytes: certificateBytes);
    return X509Certificate.fromDer(derCertificate);
  }
}
