import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:test/test.dart';

void main() {
  group(Coin, () {
    test('addition', () {
      expect(const Coin(3) + const Coin(100), equals(const Coin(103)));
      expect(const Coin(-100) + const Coin(100), equals(const Coin(0)));
    });

    test('subtraction', () {
      expect(const Coin(5) - const Coin(2), equals(const Coin(3)));
      expect(const Coin(10) - const Coin(27), equals(const Coin(-17)));
    });

    test('multiplication', () {
      expect(const Coin(3) * const Coin(6), equals(const Coin(18)));
      expect(const Coin(-5) * const Coin(7), equals(const Coin(-35)));
    });

    test('division', () {
      expect(const Coin(3) ~/ const Coin(2), equals(const Coin(1)));
      expect(const Coin(100) ~/ const Coin(50), equals(const Coin(2)));
    });

    test('comparison', () {
      expect(const Coin(3) > const Coin(2), isTrue);
      expect(const Coin(3) >= const Coin(3), isTrue);
      expect(const Coin(100) < const Coin(100), isFalse);
      expect(const Coin(100) <= const Coin(100), isTrue);
    });
  });
}
