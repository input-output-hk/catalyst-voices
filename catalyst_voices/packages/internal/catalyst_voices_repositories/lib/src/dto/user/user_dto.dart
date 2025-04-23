import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(createJsonKeys: true)
final class AccountDto {
  final String catalystId;
  final AccountEmailDto? email;
  final String keychainId;
  final Set<AccountRole> roles;
  final String? address;
  final bool isProvisional;

  AccountDto({
    required this.catalystId,
    required this.email,
    required this.keychainId,
    required this.roles,
    required this.address,
    this.isProvisional = true,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    final modifiableJson = Map.of(json);

    _jsonMigration(modifiableJson);

    return _$AccountDtoFromJson(modifiableJson);
  }

  AccountDto.fromModel(Account data)
      : this(
          catalystId: data.catalystId.toUri().toString(),
          email: data.email?.toDto(),
          keychainId: data.keychain.id,
          roles: data.roles,
          address: data.address?.toBech32(),
          isProvisional: data.isProvisional,
        );

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  Future<Account> toModel({
    required String? activeKeychainId,
    required KeychainProvider keychainProvider,
  }) async {
    final keychain = await keychainProvider.get(keychainId);
    final address = this.address;

    return Account(
      catalystId: CatalystId.fromUri(Uri.parse(catalystId)),
      email: email?.toModel(),
      keychain: keychain,
      roles: roles,
      address: address != null ? ShelleyAddress.fromBech32(address) : null,
      isActive: keychainId == activeKeychainId,
      isProvisional: isProvisional,
    );
  }

  static void _jsonMigration(Map<String, dynamic> json) {
    /// String email field is migrated into object with additional status
    /// field.
    void emailMigrationToStatus() {
      if (json.containsKey(_$AccountDtoJsonKeys.email) &&
          json[_$AccountDtoJsonKeys.email] is String) {
        json[_$AccountDtoJsonKeys.email] = AccountEmailDto(
          email: json[_$AccountDtoJsonKeys.email] as String,
          status: AccountEmailVerificationStatus.unknown,
        ).toJson();
      }
    }

    emailMigrationToStatus();
  }
}

@JsonSerializable()
final class AccountEmailDto {
  final String email;
  final AccountEmailVerificationStatus status;

  AccountEmailDto({
    required this.email,
    this.status = AccountEmailVerificationStatus.unknown,
  });

  factory AccountEmailDto.fromJson(Map<String, dynamic> json) {
    return _$AccountEmailDtoFromJson(json);
  }

  AccountEmailDto.fromModel(AccountEmail model)
      : this(
          email: model.email,
          status: model.status,
        );

  Map<String, dynamic> toJson() => _$AccountEmailDtoToJson(this);

  AccountEmail toModel() => AccountEmail(email: email, status: status);
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

  AccountWalletMetadataDto({
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
final class UserDto {
  final List<AccountDto> accounts;
  final UserSettingsDto settings;
  final String? activeKeychainId;

  UserDto({
    this.accounts = const [],
    this.settings = const UserSettingsDto(),
    this.activeKeychainId,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return _$UserDtoFromJson(json);
  }

  UserDto.fromModel(User data)
      : this(
          accounts: data.accounts.map(AccountDto.fromModel).toList(),
          settings: UserSettingsDto.fromModel(data.settings),
          activeKeychainId: data.activeAccount?.keychain.id,
        );

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
  final bool? showSubmissionClosingWarning;

  const UserSettingsDto({
    this.timezone,
    this.theme,
    this.showSubmissionClosingWarning,
  });

  factory UserSettingsDto.fromJson(Map<String, dynamic> json) {
    return _$UserSettingsDtoFromJson(json);
  }

  UserSettingsDto.fromModel(UserSettings data)
      : this(
          timezone: data.timezone,
          theme: data.theme,
          showSubmissionClosingWarning: data.showSubmissionClosingWarning,
        );

  Map<String, dynamic> toJson() => _$UserSettingsDtoToJson(this);

  UserSettings toModel() {
    return UserSettings(
      timezone: timezone,
      theme: theme,
      showSubmissionClosingWarning: showSubmissionClosingWarning,
    );
  }
}

extension on AccountEmail {
  AccountEmailDto toDto() => AccountEmailDto.fromModel(this);
}
