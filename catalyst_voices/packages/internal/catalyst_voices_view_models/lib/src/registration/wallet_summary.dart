import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

final class WalletSummaryData extends Equatable {
  final String walletName;
  final String balance;
  final String address;
  final String clipboardAddress;
  final bool showLowBalance;
  final NetworkId? showExpectedNetworkId;

  const WalletSummaryData({
    required this.walletName,
    required this.balance,
    required this.address,
    required this.clipboardAddress,
    required this.showLowBalance,
    required this.showExpectedNetworkId,
  });

  @override
  List<Object?> get props => [
        walletName,
        balance,
        address,
        clipboardAddress,
        showLowBalance,
        showExpectedNetworkId,
      ];
}
