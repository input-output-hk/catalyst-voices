import 'dart:typed_data';

import 'package:cbor/cbor.dart';

/// A set of utils to deal with deterministic CBOR as defined in:
/// https://www.rfc-editor.org/rfc/rfc8949.html#name-deterministically-encoded-c.
final class CborDeterministicUtils {
  const CborDeterministicUtils._();

  /// Creates a deterministically sorted [CborList].
  ///
  /// Applies the same set of sorting rules for the list items as applied by this spec to map keys:
  /// https://www.rfc-editor.org/rfc/rfc8949.html#name-length-first-map-key-orderi
  ///
  /// The resulting [CborList] will always be encoded as definite-length
  /// because indefinite-length must not appear as per the specification.
  static CborList createList(
    List<CborValue> items, {
    List<int> tags = const [],
  }) {
    final encodedItems = <({CborValue value, Uint8List bytes})>[
      for (final value in items)
        (
          value: value,
          bytes: Uint8List.fromList(cbor.encode(value)),
        ),
    ];

    // ignore: cascade_invocations
    encodedItems.sort(_compareDeterministicElements);

    return CborList(
      encodedItems.map((e) => e.value).toList(),
      tags: tags,
      type: CborLengthType.definite,
    );
  }

  static int _compareDeterministicElements(
    ({CborValue value, Uint8List bytes}) a,
    ({CborValue value, Uint8List bytes}) b,
  ) {
    final aSize = a.bytes.length;
    final bSize = b.bytes.length;

    if (aSize != bSize) {
      // shorter one sorts earlier
      return aSize < bSize ? -1 : 1;
    }

    for (var i = 0; i < aSize; i++) {
      final aByte = a.bytes[i];
      final bByte = b.bytes[i];

      if (aByte != bByte) {
        // the one with lower byte value sorts earlier
        return aByte < bByte ? -1 : 1;
      }
    }

    // they're the same
    return 0;
  }
}
