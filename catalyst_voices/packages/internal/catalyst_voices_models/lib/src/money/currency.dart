import 'package:equatable/equatable.dart';

// TODO(damian-molinski): Convert later using money2 package.
final class Currency extends Equatable {
  final String name;
  final String symbol;

  const Currency({
    required this.name,
    required this.symbol,
  });

  const Currency.ada()
      : this(
          name: 'ADA',
          symbol: '₳',
        );

  @override
  List<Object?> get props => [
        name,
        symbol,
      ];
}
