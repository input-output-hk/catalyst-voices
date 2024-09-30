import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkStateData extends Equatable {
  final Result<List<CardanoWallet>, Exception>? wallets;

  const WalletLinkStateData({
    this.wallets,
  });

  WalletLinkStateData copyWith({
    Optional<Result<List<CardanoWallet>, Exception>>? wallets,
  }) {
    return WalletLinkStateData(
      wallets: wallets != null ? wallets.data : this.wallets,
    );
  }

  @override
  List<Object?> get props => [wallets];
}
