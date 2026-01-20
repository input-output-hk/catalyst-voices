import 'package:catalyst_voices_models/src/document/enums/document_property_format.dart';
import 'package:catalyst_voices_models/src/money/currency_code.dart';
import 'package:catalyst_voices_models/src/money/money_model.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentCurrencyFormat, () {
    group('parse', () {
      test('parses fiat major units', () {
        final format = DocumentCurrencyFormat.parse('fiat:usd');
        expect(format, isNotNull);
        expect(format!.currency.code, equals(CurrencyCode('usd')));
        expect(format.moneyUnits, equals(MoneyUnits.majorUnits));
      });

      test('parses fiat minor units (cent)', () {
        final format = DocumentCurrencyFormat.parse('fiat:usd:cent');
        expect(format, isNotNull);
        expect(format!.currency.code, equals(CurrencyCode('usd')));
        expect(format.moneyUnits, equals(MoneyUnits.minorUnits));
      });

      test('parses token with brand and major units', () {
        final format = DocumentCurrencyFormat.parse('token:cardano:ada');
        expect(format, isNotNull);
        expect(format!.currency.code, equals(CurrencyCode('ada')));
        expect(format.moneyUnits, equals(MoneyUnits.majorUnits));
      });

      test('parses token with brand and minor units', () {
        final format = DocumentCurrencyFormat.parse('token:cardano:ada:lovelace');
        expect(format, isNotNull);
        expect(format!.currency.code, equals(CurrencyCode('ada')));
        expect(format.moneyUnits, equals(MoneyUnits.minorUnits));
      });

      test('parses token without brand (just code)', () {
        final format = DocumentCurrencyFormat.parse('token:usdm');
        expect(format, isNotNull);
        expect(format!.currency.code, equals(CurrencyCode('usdm')));
        expect(format.moneyUnits, equals(MoneyUnits.majorUnits));
      });

      test('parses token without brand, minor units', () {
        final format = DocumentCurrencyFormat.parse('token:usdm:cent');
        expect(format, isNotNull);
        expect(format!.currency.code, equals(CurrencyCode('usdm')));
        expect(format.moneyUnits, equals(MoneyUnits.minorUnits));
      });

      test('returns null for too short format', () {
        final format = DocumentCurrencyFormat.parse('usd');
        expect(format, isNull);
      });

      test('returns null for unknown currency code', () {
        final format = DocumentCurrencyFormat.parse('fiat:xyz:cent');
        expect(format, isNull);
      });

      test('returns null for unknown minor units', () {
        final format = DocumentCurrencyFormat.parse('fiat:usd:foobar');
        expect(format, isNull);
      });
    });
  });
}
