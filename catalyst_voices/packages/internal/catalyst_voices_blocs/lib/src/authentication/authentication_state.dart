part of 'authentication_bloc.dart';

final class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final SessionData? sessionData;

  const AuthenticationState.authenticated(
    SessionData sessionData,
  ) : this._(
          status: AuthenticationStatus.authenticated,
          sessionData: sessionData,
        );

  const AuthenticationState.unauthenticated()
      : this._(
          status: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.unknown() : this._();

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.sessionData,
  });

  @override
  List<Object> get props => [status, sessionData ?? ''];
}
