import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

final class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  bool get isAuthenticated =>
      state.status == AuthenticationStatus.authenticated;

  bool get isInitial => state.status == AuthenticationStatus.unknown;
  AuthenticationStatus get status => state.status;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final sessionData = await _authenticationRepository.getSessionData();

        return emit(
          sessionData != null
              ? AuthenticationState.authenticated(sessionData)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }
}
