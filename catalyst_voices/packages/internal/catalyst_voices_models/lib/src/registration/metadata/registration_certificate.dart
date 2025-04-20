import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

/// Constants for registration certificates.
final class RegistrationCertificate {
  static const stakeAddressPrefix = 'web+cardano://addr/';

  const RegistrationCertificate._();

  static String stakeAddressUri(ShelleyAddress address) {
    return stakeAddressPrefix + address.toBech32();
  }
}
