import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

abstract interface class UnlockPasswordManager {
  void setConfirmPassword(String value);

  void setPassword(String value);
}

mixin UnlockPasswordMixin implements UnlockPasswordManager {
  UnlockPasswordState _state = const UnlockPasswordState();

  UnlockPassword get password => _state.password;

  void onUnlockPasswordStateChanged(UnlockPasswordState data);

  void recoverPassword(String value) {
    setPassword(value);
    setConfirmPassword(value);
  }

  @override
  void setConfirmPassword(String value) {
    final confirmPassword = UnlockPassword.dirty(value);

    if (_state.confirmPassword != confirmPassword) {
      _updateState(confirmPassword: confirmPassword);
    }
  }

  @override
  void setPassword(String value) {
    final password = UnlockPassword.dirty(value);

    if (_state.password != password) {
      _updateState(password: password);
    }
  }

  void _updateState({
    UnlockPassword? password,
    UnlockPassword? confirmPassword,
  }) {
    password ??= _state.password;
    confirmPassword ??= _state.confirmPassword;

    final passwordStrength = password.strength();
    final isPasswordValid = password.isValid;

    final matching = password.value == confirmPassword.value;
    final hasConfirmPassword = confirmPassword.value.isNotEmpty;

    final state = UnlockPasswordState(
      password: password,
      confirmPassword: confirmPassword,
      passwordStrength: passwordStrength,
      showPasswordStrength: password.value.isNotEmpty,
      showPasswordMisMatch: isPasswordValid && hasConfirmPassword && !matching,
      isNextEnabled: isPasswordValid && matching,
    );

    if (_state != state) {
      _state = state;
      onUnlockPasswordStateChanged(state);
    }
  }
}
