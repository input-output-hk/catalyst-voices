import 'dart:async';

import 'package:catalyst_voices_blocs/src/preferences/preferences_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class PreferencesBloc extends Cubit<PreferencesState> {
  final UserService _userService;

  StreamSubscription<AccountSettings?>? _accountSettingsSub;

  PreferencesBloc(
    this._userService,
  ) : super(
          const PreferencesState(
            timezone: TimezonePreferences.local,
            theme: ThemePreferences.light,
          ),
        ) {
    _accountSettingsSub = _userService.watchAccount
        .map((account) => account?.settings)
        .distinct()
        .listen(_handleAccountSettingsChange);
  }

  @override
  Future<void> close() {
    _accountSettingsSub?.cancel();
    _accountSettingsSub = null;

    return super.close();
  }

  void _handleAccountSettingsChange(AccountSettings? settings) {
    //
  }
}
