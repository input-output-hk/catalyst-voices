import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:test/test.dart';

import '../test_utils/selection_utils.dart';

void main() {
  const config = SelectionUtils.defaultConfig;
  final changeAddress = SelectionUtils.randomAddress();

  group('TransactionBuilder Coin Selection Tests', () {
    test('selectInputs should throw an exception if funds are insufficient',
        () {
      const builder = TransactionBuilder(config: config, inputs: {});

      expect(
        builder.selectInputs,
        throwsA(isA<InsufficientUtxoBalanceException>()),
      );
    });

    group('Property-based tests for coin selection', () {
      //var i = 0;
      property(
          'Coin selection should maintain accounting properties for '
          'various UTxO and output combinations', () {
        forAll(
          maxExamples: 200,
          integer(min: 20, max: 500),
          (utxoCount) {
            final utxos = SelectionUtils.generateUtxos(
              utxoCount,
              minimumCoin: const Coin(15000000),
            );

            final outputs = SelectionUtils.outputsFromUTxos(
              inputs: utxos,
              maxOutputs: 10,
            );

            //print('#${i++}: Utxos: $utxoCount, outputs: ${outputs.length}.');
            final builder = TransactionBuilder(
              config: config,
              inputs: utxos,
              outputs: outputs,
              changeAddress: changeAddress,
            );
            expect(
              builder.selectInputs,
              anyOf([
                returnsNormally,
                throwsA(isA<MaxTxSizeExceededException>()),
                //isNot(isA<InsufficientUtxoBalanceException>()),
              ]),
            );
          },
        );
      });
    });
  });
}
