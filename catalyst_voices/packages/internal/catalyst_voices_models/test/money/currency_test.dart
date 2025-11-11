import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(Currency, () {
    group('amount', () {
      test('1 ada equals 1000000 lovelaces', () {
        // Given
        const ada = 1;
        const lovelaces = 1000000;
        const currency = Currencies.ada;

        // When
        final adaMoney = currency.amount(ada);
        final lovelaceMoney = currency.amount(lovelaces, moneyUnits: MoneyUnits.minorUnits);

        // Then
        expect(adaMoney, lovelaceMoney);
      });
    });
  });
}
