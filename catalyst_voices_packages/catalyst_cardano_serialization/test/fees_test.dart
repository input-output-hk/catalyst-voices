import 'package:catalyst_cardano_serialization/src/fees.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:test/test.dart';

import 'test_utils/test_data.dart';

void main() {
  group(LinearFee, () {
    test('minFeeNoScript with current protocol params', () {
      const linearFee = LinearFee(
        constant: Coin(155381),
        coefficient: Coin(44),
      );

      final tx = fullSignedTestTransaction();
      expect(linearFee.minNoScriptFee(tx), equals(177777));
    });

    test('minFeeNoScript with constant fee only', () {
      const linearFee = LinearFee(
        constant: Coin(155381),
        coefficient: Coin(0),
      );

      final tx = fullSignedTestTransaction();
      expect(linearFee.minNoScriptFee(tx), equals(linearFee.constant));
    });

    test('minFeeNoScript with coefficient fee only', () {
      const linearFee = LinearFee(
        constant: Coin(0),
        coefficient: Coin(44),
      );

      final tx = fullSignedTestTransaction();
      expect(linearFee.minNoScriptFee(tx), equals(22396));
    });
  });
}
