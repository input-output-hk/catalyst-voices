import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(CryptocurrencyFormatter, () {
    test('should format fractional ADA', () {
      expect(
        CryptocurrencyFormatter.formatAmount(Coin.fromAda(0.21)),
        equals('₳0.21'),
      );
    });

    test('should format less than 1000 ADA', () {
      expect(
        CryptocurrencyFormatter.formatAmount(Coin.fromAda(975)),
        equals('₳975'),
      );
    });

    test('should format  1000 ADA', () {
      expect(
        CryptocurrencyFormatter.formatAmount(Coin.fromAda(1000)),
        equals('₳1K'),
      );
    });

    test('should format amounts in thousands of ADA', () {
      expect(
        CryptocurrencyFormatter.formatAmount(Coin.fromAda(15000)),
        equals('₳15K'),
      );
    });

    test('should format amounts in millions of ADA', () {
      expect(
        CryptocurrencyFormatter.formatAmount(Coin.fromAda(2500000)),
        equals('₳2.5M'),
      );
    });

    test('should format exactly 1 million ADA', () {
      expect(
        CryptocurrencyFormatter.formatAmount(Coin.fromAda(1000000)),
        equals('₳1M'),
      );
    });
  });
}
