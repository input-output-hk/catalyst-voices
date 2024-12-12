import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_metadata.g.dart';

/// Basic information about wallet without any details.
@JsonSerializable()
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

  factory WalletMetadata.fromJson(Map<String, dynamic> json) {
    return _$WalletMetadataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WalletMetadataToJson(this);

  @override
  List<Object?> get props => [
        name,
        icon,
      ];
}
