import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:equatable/equatable.dart';

final class WalletMeta extends Equatable {
  final String name;
  final String? icon;

  const WalletMeta({
    required this.name,
    this.icon,
  });

  WalletMeta.fromCardanoWallet(CardanoWallet wallet)
      : this(
          name: wallet.name,
          icon: wallet.icon,
        );

  @override
  List<Object?> get props => [
        name,
        icon,
      ];
}
