import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
final class UserDto {
  final List<AccountDto> accounts;
  final UserSettingsDto settings;
  final String? activeKeychainId;

  UserDto({
    this.accounts = const [],
    this.settings = const UserSettingsDto(),
    this.activeKeychainId,
  });

  UserDto.fromModel(User data)
      : this(
          accounts: data.accounts.map(AccountDto.fromModel).toList(),
          settings: UserSettingsDto.fromModel(data.settings),
          activeKeychainId: data.activeAccount?.keychain.id,
        );

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return _$UserDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  Future<User> toModel({
    required KeychainProvider keychainProvider,
  }) async {
    final accounts = <Account>[];

    for (final accountDto in this.accounts) {
      final account = await accountDto.toModel(
        activeKeychainId: activeKeychainId,
        keychainProvider: keychainProvider,
      );

      accounts.add(account);
    }

    return User(
      accounts: accounts,
      settings: settings.toModel(),
    );
  }
}

@JsonSerializable()
final class UserSettingsDto {
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final TimezonePreferences? timezone;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ThemePreferences? theme;

  const UserSettingsDto({
    this.timezone,
    this.theme,
  });

  UserSettingsDto.fromModel(UserSettings data)
      : this(
          timezone: data.timezone,
          theme: data.theme,
        );

  factory UserSettingsDto.fromJson(Map<String, dynamic> json) {
    return _$UserSettingsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserSettingsDtoToJson(this);

  UserSettings toModel() {
    return UserSettings(
      timezone: timezone,
      theme: theme,
    );
  }
}

@JsonSerializable(createJsonKeys: true)
final class AccountDto {
  final String displayName;
  final String email;
  final String keychainId;
  final Set<AccountRole> roles;
  final AccountWalletInfoDto walletInfo;
  final bool isProvisional;

  AccountDto({
    required this.displayName,
    required this.email,
    required this.keychainId,
    required this.roles,
    required this.walletInfo,
    this.isProvisional = true,
  });

  AccountDto.fromModel(Account data)
      : this(
          displayName: data.displayName,
          email: data.email,
          keychainId: data.keychain.id,
          roles: data.roles,
          walletInfo: AccountWalletInfoDto.fromModel(data.walletInfo),
          isProvisional: data.isProvisional,
        );

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    final modifiableJson = Map.of(json);

    _jsonMigration(modifiableJson);

    return _$AccountDtoFromJson(modifiableJson);
  }

  static void _jsonMigration(Map<String, dynamic> json) {
    /// displayName and email were added later and some existing accounts
    /// are already stored without them but we still don't want to make
    /// those fields optional.
    void baseProfileMigration() {
      if (!json.containsKey(_$AccountDtoJsonKeys.displayName)) {
        json[_$AccountDtoJsonKeys.displayName] = 'Migrated';
      }
      if (!json.containsKey(_$AccountDtoJsonKeys.email)) {
        json[_$AccountDtoJsonKeys.email] = 'migrated@iohk.com';
      }
    }

    baseProfileMigration();
  }

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  Future<Account> toModel({
    required String? activeKeychainId,
    required KeychainProvider keychainProvider,
  }) async {
    final keychain = await keychainProvider.get(keychainId);

    return Account(
      displayName: displayName,
      email: email,
      keychain: keychain,
      roles: roles,
      walletInfo: walletInfo.toModel(),
      isActive: keychainId == activeKeychainId,
      isProvisional: isProvisional,
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

  AccountWalletInfoDto({
    required this.metadata,
    required this.balance,
    required this.address,
  });

  AccountWalletInfoDto.fromModel(WalletInfo data)
      : this(
          metadata: AccountWalletMetadataDto.fromModel(data.metadata),
          balance: data.balance,
          address: data.address,
        );

  factory AccountWalletInfoDto.fromJson(Map<String, dynamic> json) {
    return _$AccountWalletInfoDtoFromJson(json);
  }

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

  AccountWalletMetadataDto({
    required this.name,
    this.icon,
  });

  AccountWalletMetadataDto.fromModel(WalletMetadata data)
      : this(
          name: data.name,
          icon: data.icon,
        );

  factory AccountWalletMetadataDto.fromJson(Map<String, dynamic> json) {
    return _$AccountWalletMetadataDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AccountWalletMetadataDtoToJson(this);

  WalletMetadata toModel() {
    return WalletMetadata(
      name: name,
      icon: icon,
    );
  }
}
