part of 'login_bloc.dart';

final class LoginState extends Equatable with FormzMixin {
  final FormzSubmissionStatus status;
  final Email email;
  final Password password;

  LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  @override
  List<FormzInput<Object, Object>> get inputs => [email, password];

  @override
  List<Object> get props => [
        status,
        email,
        password,
      ];

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
