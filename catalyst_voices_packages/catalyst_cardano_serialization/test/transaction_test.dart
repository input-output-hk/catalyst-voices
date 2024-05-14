import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

import 'utils/test_data.dart';

void main() {
  group(Transaction, () {
    test('transaction with all supported fields serialized to bytes', () {
      final bytes = cbor.encode(fullTestTransaction().toCbor());
      final hexString = hex.encode(bytes);

      expect(
        hexString,
        equals(
          '84a40081825820583a3a5150bc7990656020ffb4e5a1be1589ce6f1a430aacb8e7e0'
          '89b894d3d101018182581d609493315cd92eb5d8c4304e67b7e16ae36d61d3450269'
          '4657811a2c8e1a004c4b40021a009896800319a029a0f5a1016454657374',
        ),
      );
    });

    test('transaction with required fields serialized to bytes', () {
      final bytes = cbor.encode(minimalTestTransaction().toCbor());
      final hexString = hex.encode(bytes);

      expect(
        hexString,
        equals(
          '84a30081825820583a3a5150bc7990656020ffb4e5a1be1589ce6f1a430aacb8e7e0'
          '89b894d3d101018182581d609493315cd92eb5d8c4304e67b7e16ae36d61d3450269'
          '4657811a2c8e1a004c4b40021a00989680a0f5d90103a0',
        ),
      );
    });
  });
}
