import 'package:equatable/equatable.dart';

final class WalletSummaryData extends Equatable {
  final String balance;
  final String address;
  final String clipboardAddress;
  final bool showLowBalance;

  const WalletSummaryData({
    required this.balance,
    required this.address,
    required this.clipboardAddress,
    required this.showLowBalance,
  });

  @override
  List<Object?> get props => [
        balance,
        address,
        clipboardAddress,
        showLowBalance,
      ];
}
