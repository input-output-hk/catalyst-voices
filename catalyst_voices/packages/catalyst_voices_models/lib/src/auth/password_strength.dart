import 'package:password_strength/password_strength.dart' as ps;

/// Describes strength of a password.
///
/// The enum values must be sorted from the weakest to the strongest.
enum PasswordStrength {
  /// A weak password. Simple, already exposed, commonly used, etc.
  weak,

  /// A medium password, not complex.
  normal,

  /// A complex password with characters from different groups.
  strong;

  /// The minimum length of accepted password.
  static const int minimumLength = 8;

  factory PasswordStrength.calculate(String text) {
    if (text.length < minimumLength) return PasswordStrength.weak;

    final strength = ps.estimatePasswordStrength(text);
    if (strength <= 0.33) return PasswordStrength.weak;
    if (strength <= 0.66) return PasswordStrength.normal;
    return PasswordStrength.strong;
  }
}
