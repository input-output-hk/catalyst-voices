import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:equatable/equatable.dart';

/// A state describing available cardano wallet extensions.
sealed class AvailableCardanoWallets extends Equatable {
  const AvailableCardanoWallets();
}

/// Cardano wallets are not loaded yet.
final class UninitializedCardanoWallets extends AvailableCardanoWallets {
  const UninitializedCardanoWallets();

  @override
  List<Object?> get props => [];
}

/// A list of cardano [wallets], might be empty.
final class CardanoWalletsList extends AvailableCardanoWallets {
  final List<CardanoWallet> wallets;

  const CardanoWalletsList({required this.wallets});

  @override
  List<Object?> get props => [wallets];
}

/// An error happened when fetching cardano wallets.
final class CardanoWalletsError extends AvailableCardanoWallets {
  final Object error;

  const CardanoWalletsError({required this.error});

  @override
  List<Object?> get props => [error];
}
