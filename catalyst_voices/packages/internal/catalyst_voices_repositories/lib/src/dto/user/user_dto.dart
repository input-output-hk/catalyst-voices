import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/user/account_dto.dart';
import 'package:catalyst_voices_repositories/src/user/keychain/keychain_provider.dart';
import 'package:catalyst_voices_repositories/src/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
final class UserDto {
  final List<AccountDto> accounts;
  final UserSettingsDto settings;
  final String? activeKeychainId;

  const UserDto({
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
