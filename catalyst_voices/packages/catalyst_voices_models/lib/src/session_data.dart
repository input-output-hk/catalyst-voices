import 'package:meta/meta.dart';

@immutable
class SessionData {
  final String? email;
  final String? password;

  const SessionData({
    required this.email,
    required this.password,
  });

  factory SessionData.empty() {
    return const SessionData(
      email: null,
      password: null,
    );
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SessionData &&
        other.email == email &&
        other.password == password;
  }

  @override
  String toString() => 'SessionData(email: $email, password: $password)';
}
