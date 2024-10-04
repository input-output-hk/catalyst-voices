import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

/// Formats [ShelleyAddress].
abstract class WalletAddressFormatter {
  /* cSpell:disable */
  /// Formats the [address] into short representation.
  ///
  /// Formats "addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw"
  /// into "addr_test1v…6tkw".
  /* cSpell:enable */
  static String formatShort(ShelleyAddress address) {
    final str = address.toBech32();
    return '${str.substring(0, 11)}…${str.substring(str.length - 4)}';
  }
}
