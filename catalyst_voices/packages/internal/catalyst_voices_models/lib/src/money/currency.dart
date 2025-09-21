import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart' as money2;

final class Currency extends Equatable {
  final String isoCode;
  final String symbol;
  final int decimalDigits;
  final String pattern;

  const Currency({
    required this.isoCode,
    required this.symbol,
    required this.decimalDigits,
    required this.pattern,
  });

  const Currency.ada()
    : this(
        isoCode: 'ADA',
        symbol: '₳',
        decimalDigits: 6,
        pattern: 'S0.##',
      );

  const Currency.usd()
    : this(
        isoCode: 'USD',
        symbol: r'$',
        decimalDigits: 2,
        pattern: 'S0.00',
      );

  @override
  List<Object?> get props => [
    isoCode,
    symbol,
  ];

  String format(BigInt minorUnits) {
    final currency = money2.Currency.create(
      isoCode,
      decimalDigits,
      pattern: pattern,
      symbol: symbol,
    );
    final money = money2.Money.fromBigIntWithCurrency(minorUnits, currency);
    return money.format();
  }
}

final class Money extends Equatable {
  final Currency currency;
  final BigInt minorUnits;

  const Money({
    required this.currency,
    required this.minorUnits,
  });

  Money.fromMajorUnits({
    required this.currency,
    required BigInt majorUnits,
  }) : minorUnits = majorUnits * BigInt.from(pow(10, currency.decimalDigits));

  @override
  List<Object?> get props => [currency, minorUnits];

  String format() {
    return currency.format(minorUnits);
  }
}
