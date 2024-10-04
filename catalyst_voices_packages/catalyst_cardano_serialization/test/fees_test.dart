import 'package:catalyst_cardano_serialization/src/fees.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:test/test.dart';

import 'test_utils/test_data.dart';

void main() {
  final txInputs = {
    testUtxo(index: 0, scriptRef: refInputScripts[0]),
    testUtxo(index: 1, scriptRef: refInputScripts[1]),
    testUtxo(index: 2, scriptRef: refInputScripts[2]),
  };

  final refInputs = {
    testUtxo(index: 3, scriptRef: refInputScripts[0]),
    testUtxo(index: 4, scriptRef: refInputScripts[1]),
    testUtxo(index: 5, scriptRef: refInputScripts[2]),
  };

  group(TieredFee, () {
    test('minFee with current protocol params', () {
      const tieredFee = TieredFee(
        constant: 155381,
        coefficient: 44,
        refScriptByteCost: 15,
      );

      final tx = fullSignedTestTransaction();
      expect(tieredFee.minFee(tx, {}), equals(const Coin(177777)));
    });

    test('minFee with constant fee only', () {
      const tieredFee = TieredFee(
        constant: 155381,
        coefficient: 0,
        refScriptByteCost: 15,
      );

      final tx = fullSignedTestTransaction();
      expect(tieredFee.minFee(tx, {}), equals(Coin(tieredFee.constant)));
    });

    test('minFee with coefficient fee only', () {
      const tieredFee = TieredFee(
        constant: 0,
        coefficient: 44,
        refScriptByteCost: 15,
      );

      final tx = fullSignedTestTransaction();
      expect(tieredFee.minFee(tx, {}), equals(const Coin(22396)));
    });

    test('refScriptFee is a linear function when multiplier is 1', () {
      const scriptByteFee = 15;
      const size = 500;

      const tieredFee = TieredFee(
        constant: 155381,
        coefficient: 44,
        multiplier: 1,
        refScriptByteCost: 15,
      );

      const expectedFee = size * scriptByteFee;
      final actualFee = tieredFee.refScriptFee(
        1,
        tieredFee.sizeIncrement,
        scriptByteFee,
        size,
      );

      expect(actualFee, equals(expectedFee));
    });

    test('tierRefScriptFee with tiered pricing', () {
      const multiplier = 1.5;
      const sizeIncrement = 25600;
      const baseFee = 15;

      const tieredFee = TieredFee(
        constant: 0,
        coefficient: 44,
        refScriptByteCost: 15,
      );

      const sizes = [
        0,
        sizeIncrement,
        2 * sizeIncrement,
        3 * sizeIncrement,
        4 * sizeIncrement,
        5 * sizeIncrement,
        6 * sizeIncrement,
        7 * sizeIncrement,
        8 * sizeIncrement,
      ];

      const expectedFees = [
        0,
        384000,
        960000,
        1824000,
        3120000,
        5064000,
        7980000,
        12354000,
        18915000,
      ];
      final actualFees = sizes
          .map(
            (size) => tieredFee.refScriptFee(
              multiplier,
              sizeIncrement,
              baseFee,
              size,
            ),
          )
          .toList();

      expect(actualFees, equals(expectedFees));
    });

    test('refScriptFee for a large reference script size and multiplier', () {
      const tieredFee = TieredFee(
        constant: 155381,
        coefficient: 44,
        multiplier: 1.5,
        refScriptByteCost: 15,
      );

      const size = 100000;
      const expectedFee = 2998500;
      final actualFee = tieredFee.refScriptFee(
        tieredFee.multiplier,
        tieredFee.sizeIncrement,
        tieredFee.refScriptByteCost,
        size,
      );

      expect(actualFee, equals(expectedFee));
    });

    test('tieredFee and refScriptFee calculations', () {
      const byteCost = 15;
      const tieredFee = TieredFee(
        constant: 155381,
        coefficient: 44,
        refScriptByteCost: byteCost,
      );

      const txBytes = 10000;
      const refScriptsBytes = 5000;

      final linearFee = tieredFee.linearFee(txBytes);
      final scriptFee =
          tieredFee.refScriptFee(1.5, 25600, byteCost, refScriptsBytes);
      final expectedFee = Coin(linearFee + scriptFee);
      final actualFee = tieredFee.tieredFee(txBytes, refScriptsBytes);

      expect(actualFee, equals(expectedFee));
    });
  });

  test('minFee for a large transaction with multiple reference scripts', () {
    const tieredFee = TieredFee(
      constant: 155381,
      coefficient: 44,
      refScriptByteCost: 15,
    );

    final inputs = txInputs.map((utxo) => utxo.input).toSet();

    final tx = fullSignedTestTransaction(inputs: inputs);
    final sum =
        refInputScriptsSizes.reduce((value, element) => value + element);

    final refScriptsFee = tieredFee.refScriptFee(
      tieredFee.multiplier,
      tieredFee.sizeIncrement,
      tieredFee.refScriptByteCost,
      sum,
    );

    const expectedFee = 180945;

    final minNoScriptFee = tieredFee.minFee(tx, {});

    // With no reference scripts.
    expect(minNoScriptFee, equals(const Coin(expectedFee)));

    expect(
      tieredFee.minFee(tx, refInputs),
      equals(minNoScriptFee + Coin(refScriptsFee)),
    );
  });

  test('minFee for a large transaction with duplicate reference scripts', () {
    const tieredFee = TieredFee(
      constant: 155381,
      coefficient: 44,
      refScriptByteCost: 15,
    );

    final inputs =
        {...txInputs, ...refInputs}.map((utxo) => utxo.input).toSet();

    final tx = fullSignedTestTransaction(inputs: inputs);
    final sum =
        refInputScriptsSizes.reduce((value, element) => value + element);

    final refScriptsFee = tieredFee.refScriptFee(
      tieredFee.multiplier,
      tieredFee.sizeIncrement,
      tieredFee.refScriptByteCost,
      2 * sum,
    );

    const expectedFee = 185697;

    final minNoScriptFee = tieredFee.minFee(tx, {});

    // With no reference scripts.
    expect(minNoScriptFee, equals(const Coin(expectedFee)));

    expect(
      tieredFee.minFee(tx, {...txInputs, ...refInputs}),
      equals(minNoScriptFee + Coin(refScriptsFee)),
    );
  });
}
