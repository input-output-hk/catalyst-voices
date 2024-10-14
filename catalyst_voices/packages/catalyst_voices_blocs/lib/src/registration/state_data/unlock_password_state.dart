import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class UnlockPasswordState extends Equatable {
  final UnlockPassword password;
  final UnlockPassword confirmPassword;
  final PasswordStrength passwordStrength;
  final bool showPasswordStrength;
  final int minPasswordLength;
  final bool showPasswordMisMatch;
  final bool isNextEnabled;

  const UnlockPasswordState({
    this.password = const UnlockPassword.pure(),
    this.confirmPassword = const UnlockPassword.pure(),
    this.passwordStrength = PasswordStrength.weak,
    this.showPasswordStrength = false,
    this.minPasswordLength = PasswordStrength.minimumLength,
    this.showPasswordMisMatch = false,
    this.isNextEnabled = false,
  });

  UnlockPasswordState copyWith({
    UnlockPassword? password,
    UnlockPassword? confirmPassword,
    PasswordStrength? passwordStrength,
    bool? showPasswordStrength,
    int? minPasswordLength,
    bool? showPasswordMisMatch,
    bool? isNextEnabled,
  }) {
    return UnlockPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      showPasswordStrength: showPasswordStrength ?? this.showPasswordStrength,
      minPasswordLength: minPasswordLength ?? this.minPasswordLength,
      showPasswordMisMatch: showPasswordMisMatch ?? this.showPasswordMisMatch,
      isNextEnabled: isNextEnabled ?? this.isNextEnabled,
    );
  }

  @override
  List<Object?> get props => [
        password,
        confirmPassword,
        passwordStrength,
        showPasswordStrength,
        minPasswordLength,
        showPasswordMisMatch,
        isNextEnabled,
      ];
}
