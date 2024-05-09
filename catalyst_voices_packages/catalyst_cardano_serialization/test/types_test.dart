import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:test/test.dart';

void main() {
  group(Coin, () {
    test('addition', () {
      expect(Coin(3) + Coin(100), equals(Coin(103)));
      expect(Coin(-100) + Coin(100), equals(Coin(0)));
    });

    test('subtraction', () {
      expect(Coin(5) - Coin(2), equals(Coin(3)));
      expect(Coin(10) - Coin(27), equals(Coin(-17)));
    });

    test('multiplication', () {
      expect(Coin(3) * Coin(6), equals(Coin(18)));
      expect(Coin(-5) * Coin(7), equals(Coin(-35)));
    });

    test('division', () {
      expect(Coin(3) ~/ Coin(2), equals(Coin(1)));
      expect(Coin(100) ~/ Coin(50), equals(Coin(2)));
    });

    test('comparison', () {
      expect(Coin(3) > Coin(2), isTrue);
      expect(Coin(100) < Coin(50), isFalse);
    });
  });
}
