import 'package:equatable/equatable.dart';

// TODO(damian-molinski): Convert later using money2 package.
/// Encapsulates currency related operations. At the moment only ada is supported.
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

  /// Returns formated [money] with prefix of this [Currency][symbol].
  String format(num money) {
    return '$symbol$money';
  }
}
