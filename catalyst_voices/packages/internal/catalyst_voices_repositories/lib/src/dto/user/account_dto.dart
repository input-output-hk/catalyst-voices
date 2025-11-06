import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/user/keychain/keychain_provider.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable(createJsonKeys: true)
final class AccountDto {
  final String catalystId;
  final String? email;
  final String keychainId;
  final Set<AccountRole> roles;
  final String? address;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final AccountPublicStatus? publicStatus;
  final VotingPowerDto? votingPower;
  final AccountRegistrationStatusDto? registrationStatus;

  const AccountDto({
    required this.catalystId,
    this.email,
    required this.keychainId,
    required this.roles,
    required this.address,
    this.publicStatus,
    this.votingPower,
    this.registrationStatus,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    final modifiableJson = Map.of(json);

    _jsonMigration(modifiableJson);

    return _$AccountDtoFromJson(modifiableJson);
  }

  AccountDto.fromModel(Account data)
    : this(
        catalystId: data.catalystId.toUri().toString(),
        email: data.email,
        keychainId: data.keychain.id,
        roles: data.roles,
        address: data.address?.toBech32(),
        publicStatus: data.publicStatus,
        votingPower: data.votingPower != null ? VotingPowerDto.fromModel(data.votingPower!) : null,
        registrationStatus: AccountRegistrationStatusDto.fromModel(data.registrationStatus),
      );

  // As part of migration falling back to unknown if email is not set.
  AccountPublicStatus get _publicStatus {
    return publicStatus ??
        (email != null ? AccountPublicStatus.unknown : AccountPublicStatus.notSetup);
  }

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  Future<Account> toModel({
    required String? activeKeychainId,
    required KeychainProvider keychainProvider,
  }) async {
    final keychain = await keychainProvider.get(keychainId);
    final address = this.address;

    return Account(
      catalystId: CatalystId.parse(catalystId),
      email: email,
      keychain: keychain,
      roles: roles,
      address: address != null ? ShelleyAddress.fromBech32(address) : null,
      publicStatus: _publicStatus,
      votingPower: votingPower?.toModel(),
      isActive: keychainId == activeKeychainId,
      registrationStatus:
          registrationStatus?.toModel() ??
          // This assumes already existing accounts are indexed and persistent
          const AccountRegistrationStatus.indexed(isPersistent: true),
    );
  }

  static void _jsonMigration(Map<String, dynamic> json) {
    // empty at the moment.
  }
}

@JsonSerializable()
final class AccountRegistrationStatusDto {
  final bool isIndexed;
  final bool isPersistent;

  AccountRegistrationStatusDto({
    required this.isIndexed,
    required this.isPersistent,
  });

  factory AccountRegistrationStatusDto.fromJson(Map<String, dynamic> json) {
    return _$AccountRegistrationStatusDtoFromJson(json);
  }

  AccountRegistrationStatusDto.fromModel(AccountRegistrationStatus data)
    : this(
        isIndexed: data.isIndexed,
        isPersistent: data.isPersistent,
      );

  Map<String, dynamic> toJson() => _$AccountRegistrationStatusDtoToJson(this);

  AccountRegistrationStatus toModel() {
    return AccountRegistrationStatus(
      isIndexed: isIndexed,
      isPersistent: isPersistent,
    );
  }
}

@JsonSerializable()
final class AccountWalletInfoDto {
  final AccountWalletMetadataDto metadata;
  @CoinConverter()
  final Coin balance;
  @ShelleyAddressConverter()
  final ShelleyAddress address;

  const AccountWalletInfoDto({
    required this.metadata,
    required this.balance,
    required this.address,
  });

  factory AccountWalletInfoDto.fromJson(Map<String, dynamic> json) {
    return _$AccountWalletInfoDtoFromJson(json);
  }

  AccountWalletInfoDto.fromModel(WalletInfo data)
    : this(
        metadata: AccountWalletMetadataDto.fromModel(data.metadata),
        balance: data.balance,
        address: data.address,
      );

  Map<String, dynamic> toJson() => _$AccountWalletInfoDtoToJson(this);

  WalletInfo toModel() {
    return WalletInfo(
      metadata: metadata.toModel(),
      balance: balance,
      address: address,
    );
  }
}

@JsonSerializable()
final class AccountWalletMetadataDto {
  final String name;
  final String? icon;

  const AccountWalletMetadataDto({
    required this.name,
    this.icon,
  });

  factory AccountWalletMetadataDto.fromJson(Map<String, dynamic> json) {
    return _$AccountWalletMetadataDtoFromJson(json);
  }

  AccountWalletMetadataDto.fromModel(WalletMetadata data)
    : this(
        name: data.name,
        icon: data.icon,
      );

  Map<String, dynamic> toJson() => _$AccountWalletMetadataDtoToJson(this);

  WalletMetadata toModel() {
    return WalletMetadata(
      name: name,
      icon: icon,
    );
  }
}

@JsonSerializable()
final class VotingPowerDto {
  final int amount;
  @JsonKey(unknownEnumValue: VotingPowerStatus.provisional)
  final VotingPowerStatus status;
  final DateTime updatedAt;

  const VotingPowerDto({
    required this.amount,
    required this.status,
    required this.updatedAt,
  });

  factory VotingPowerDto.fromJson(Map<String, dynamic> json) {
    return _$VotingPowerDtoFromJson(json);
  }

  VotingPowerDto.fromModel(VotingPower model)
    : this(
        amount: model.amount,
        status: model.status,
        updatedAt: model.updatedAt,
      );

  Map<String, dynamic> toJson() => _$VotingPowerDtoToJson(this);

  VotingPower toModel() {
    return VotingPower(
      amount: amount,
      status: status,
      updatedAt: updatedAt,
    );
  }
}
