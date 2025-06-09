import 'package:convert/convert.dart';

/// Decodes the hex [hexData] encoded with "0x" prefix".
///
/// The "0x" is not a valid hex, it's barely a "decoration" which describes
/// data encoding but is not a valid data itself.
List<int> hexDecode(String hexData) {
  if (hexData.startsWith('0x')) {
    final unformatted = hexData.replaceFirst('0x', '');
    return hex.decode(unformatted);
  }

  return hex.decode(hexData);
}
