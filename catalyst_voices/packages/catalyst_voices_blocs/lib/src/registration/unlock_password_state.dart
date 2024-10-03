import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class UnlockPasswordState extends Equatable {
  final String password;
  final String confirmPassword;
  final PasswordStrength passwordStrength;
  final bool showPasswordStrength;
  final int minPasswordLength;
  final bool showPasswordMisMatch;
  final bool isNextEnabled;

  const UnlockPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.passwordStrength = PasswordStrength.weak,
    this.showPasswordStrength = false,
    this.minPasswordLength = PasswordStrength.minimumLength,
    this.showPasswordMisMatch = false,
    this.isNextEnabled = false,
  });

  UnlockPasswordState copyWith({
    String? password,
    String? confirmPassword,
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
