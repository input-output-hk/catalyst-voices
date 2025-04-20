import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';

extension RbacRegistrationChainExt on RbacRegistrationChain {
  Set<AccountRole> get accountRoles {
    final map = roles as Map<String, dynamic>;
    final roleNumbers = map.keys.map(int.tryParse);
    final accountRoles =
        roleNumbers.map(AccountRole.maybeFromNumber).nonNulls.toSet();

    if (!accountRoles.contains(AccountRole.root)) {
      throw ArgumentError.value(
        roles,
        'roles',
        'Did not contain mandatory root role.',
      );
    }

    return accountRoles;
  }

  ShelleyAddress get stakeAddress {
    final map = roles as Map<String, dynamic>;
    final rootRole =
        map[AccountRole.root.number.toString()] as Map<String, dynamic>?;
    if (rootRole == null) {
      throw ArgumentError.value(
        roles,
        'roles',
        'Did not contain mandatory root role.',
      );
    }

    final signingKeys = rootRole['signing_keys'] as List<dynamic>;
    final signingKey = signingKeys.firstOrNull as Map<String, dynamic>?;
    if (signingKey == null) {
      throw ArgumentError.notNull('signingKey');
    }

    final signingKeyType = signingKey['key_type'] as String;
    final signingKeyValue = signingKey['key_value'] as String;

    if (signingKeyType != 'x509') {
      throw ArgumentError.value(
        signingKeyType,
        'signingKeyType',
        'Was not a x509 key.',
      );
    }

    final certificateBytes = hex.decode(signingKeyValue.replaceFirst('0x', ''));
    final derCertificate =
        X509DerCertificate.fromBytes(bytes: certificateBytes);
    final x509Certificate = X509Certificate.fromDer(derCertificate);
    final extensions = x509Certificate.tbsCertificate.extensions;
    if (extensions == null) {
      throw ArgumentError.notNull('extensions');
    }

    final subjectAltName = extensions.subjectAltName;
    if (subjectAltName == null) {
      throw ArgumentError.notNull('subjectAltName');
    }

    final stakeAddressExt = subjectAltName.firstWhereOrNull(
      (e) => e.value.startsWith(RegistrationCertificate.stakeAddressPrefix),
    );

    if (stakeAddressExt == null) {
      throw ArgumentError.notNull('stakeAddressExt');
    }

    final index = stakeAddressExt.value
        .indexOf(RegistrationCertificate.stakeAddressPrefix);
    final stakeAddressBech32 = stakeAddressExt.value
        .substring(index + RegistrationCertificate.stakeAddressPrefix.length);
    return ShelleyAddress.fromBech32(stakeAddressBech32);
  }
}
