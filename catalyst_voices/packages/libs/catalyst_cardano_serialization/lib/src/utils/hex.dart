import 'package:convert/convert.dart';

/// Decodes the hex [string] encoded with "0x" prefix".
///
/// The "0x" is not a valid hex, it's barely a "decoration" which describes
/// data encoding but is not a valid data itself.
List<int> hexDecode(String string) {
  final unformatted = string.replaceFirst('0x', '');
  return hex.decode(unformatted);
}
