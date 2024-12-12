import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/json_converters.dart';
import 'package:catalyst_voices_models/src/wallet/wallet_metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_info.g.dart';

/// This class represents basic information's about Wallet,
/// such as [CardanoWallet], but without specifying way to take action like
/// enable.
///
/// Instance of this class can come from different places like backend
/// or user interacting with wallet extension.
@JsonSerializable()
final class WalletInfo extends Equatable {
  final WalletMetadata metadata;
  @CoinConverter()
  final Coin balance;
  @ShelleyAddressConverter()
  final ShelleyAddress address;

  const WalletInfo({
    required this.metadata,
    required this.balance,
    required this.address,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return _$WalletInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WalletInfoToJson(this);

  @override
  List<Object?> get props => [
        metadata,
        balance.value,
        address,
      ];
}
