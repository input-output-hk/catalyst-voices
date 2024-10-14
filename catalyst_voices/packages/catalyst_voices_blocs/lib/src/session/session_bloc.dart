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
      emit(ActiveUserSessionState(user: _dummyUser));
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

  Future<void> _onVisitorEvent(
    VisitorSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychainService.remove();

    emit(const VisitorSessionState());
  }

  Future<void> _onGuestEvent(
    GuestSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychainService.init(
      seedPhrase: _dummySeedPhrase,
      unlockFactor: _dummyUnlockFactor,
    );

    emit(const GuestSessionState());
  }

  Future<void> _onActiveUserEvent(
    ActiveUserSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychainService.init(
      seedPhrase: _dummySeedPhrase,
      unlockFactor: _dummyUnlockFactor,
    );

    await _keychainService.unlock(_dummyUnlockFactor);

    emit(ActiveUserSessionState(user: _dummyUser));
  }

  Future<void> _onRemoveKeychainEvent(
    RemoveKeychainSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychainService.remove();
    emit(const VisitorSessionState());
  }

  /// Temporary implementation for testing purposes.
  User get _dummyUser => const User(name: 'Account');

  /// Temporary implementation for testing purposes.
  SeedPhrase get _dummySeedPhrase => SeedPhrase.fromMnemonic(
        'few loyal swift champion rug peace dinosaur'
        ' erase bacon tone install universe',
      );

  /// Temporary implementation for testing purposes.
  LockFactor get _dummyUnlockFactor => const PasswordLockFactor('Test1234');
}
