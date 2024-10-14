import 'package:catalyst_voices_blocs/src/session/session_event.dart';
import 'package:catalyst_voices_blocs/src/session/session_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO(dtscalac): unlock session
/// Manages the user session.
final class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final KeychainService _keychainService;

  SessionBloc(this._keychainService) : super(const VisitorSessionState()) {
    on<RestoreSessionEvent>(_onRestoreSessionEvent);
    on<NextStateSessionEvent>(_onNextStateEvent);
    on<VisitorSessionEvent>(_onVisitorEvent);
    on<GuestSessionEvent>(_onGuestEvent);
    on<ActiveUserSessionEvent>(_onActiveUserEvent);
    on<RemoveKeychainSessionEvent>(_onRemoveKeychainEvent);
  }

  Future<void> _onRestoreSessionEvent(
    RestoreSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    if (!await _keychainService.hasSeedPhrase) {
      emit(const VisitorSessionState());
    } else if (await _keychainService.isUnlocked) {
      emit(ActiveUserSessionState(user: _user));
    } else {
      emit(const GuestSessionState());
    }
  }

  void _onNextStateEvent(
    NextStateSessionEvent event,
    Emitter<SessionState> emit,
  ) {
    final nextState = switch (state) {
      VisitorSessionState() => const GuestSessionState(),
      GuestSessionState() => const ActiveUserSessionState(
          user: User(name: 'Account'),
        ),
      ActiveUserSessionState() => const VisitorSessionState(),
    };

    emit(nextState);
  }

  void _onVisitorEvent(
    VisitorSessionEvent event,
    Emitter<SessionState> emit,
  ) {
    emit(const VisitorSessionState());
  }

  void _onGuestEvent(
    GuestSessionEvent event,
    Emitter<SessionState> emit,
  ) {
    emit(const GuestSessionState());
  }

  void _onActiveUserEvent(
    ActiveUserSessionEvent event,
    Emitter<SessionState> emit,
  ) {
    emit(ActiveUserSessionState(user: _user));
  }

  Future<void> _onRemoveKeychainEvent(
    RemoveKeychainSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychainService.remove();
    emit(const VisitorSessionState());
  }

  /// A dummy user.
  User get _user => const User(name: 'Account');
}
