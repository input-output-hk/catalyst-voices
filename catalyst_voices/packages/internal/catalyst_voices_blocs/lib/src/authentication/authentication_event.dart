part of 'authentication_bloc.dart';

abstract final class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  final AuthenticationStatus status;

  const _AuthenticationStatusChanged(this.status);
}
