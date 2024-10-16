import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:equatable/equatable.dart';

/// Basic information about wallet without any details.
final class WalletMetadata extends Equatable {
  final String name;
  final String? icon;

  const WalletMetadata({
    required this.name,
    this.icon,
  });

  WalletMetadata.fromCardanoWallet(CardanoWallet wallet)
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
