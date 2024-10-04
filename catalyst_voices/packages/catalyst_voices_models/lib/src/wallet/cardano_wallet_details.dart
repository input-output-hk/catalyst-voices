import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

/// Describes the details of an enabled wallet.
final class CardanoWalletDetails extends Equatable {
  /// The minimum amount of ADA the user
  /// must posses to proceed with the registration.
  static final Coin minAdaForRegistration = Coin.fromAda(1);

  final CardanoWallet wallet;
  final Coin balance;
  final ShelleyAddress address;

  bool get hasEnoughBalance => balance >= minAdaForRegistration;

  const CardanoWalletDetails({
    required this.wallet,
    required this.balance,
    required this.address,
  });

  @override
  List<Object?> get props => [wallet, balance, address];
}
