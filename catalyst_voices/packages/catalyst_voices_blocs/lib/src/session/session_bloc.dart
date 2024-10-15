import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/src/session/session_event.dart';
import 'package:catalyst_voices_blocs/src/session/session_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO(dtscalac): unlock session
/// Manages the user session.
final class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final Keychain _keychain;

  SessionBloc(this._keychain) : super(const VisitorSessionState()) {
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
    if (!await _keychain.hasSeedPhrase) {
      emit(const VisitorSessionState());
    } else if (await _keychain.isUnlocked) {
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
      GuestSessionState() => ActiveUserSessionState(user: _dummyUser),
      ActiveUserSessionState() => const VisitorSessionState(),
    };

    emit(nextState);
  }

  Future<void> _onVisitorEvent(
    VisitorSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychain.clearAndLock();

    emit(const VisitorSessionState());
  }

  Future<void> _onGuestEvent(
    GuestSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychain.setLockAndBeginWith(
      seedPhrase: _dummySeedPhrase,
      unlockFactor: _dummyUnlockFactor,
      unlocked: false,
    );

    emit(const GuestSessionState());
  }

  Future<void> _onActiveUserEvent(
    ActiveUserSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychain.setLockAndBeginWith(
      seedPhrase: _dummySeedPhrase,
      unlockFactor: _dummyUnlockFactor,
      unlocked: true,
    );

    emit(ActiveUserSessionState(user: _dummyUser));
  }

  Future<void> _onRemoveKeychainEvent(
    RemoveKeychainSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _keychain.clearAndLock();
    emit(const VisitorSessionState());
  }

  /// Temporary implementation for testing purposes.
  User get _dummyUser {
    /* cSpell:disable */
    return User(
      profile: Profile(
        walletHeader: WalletHeader(
          meta: const WalletMetadata(
            name: 'Dummy Wallet',
            icon: null,
          ),
          balance: Coin.fromAda(10),
          address: ShelleyAddress.fromBech32(
            'addr_test1vzpwq95z3xyum8vqndgdd'
            '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
          ),
        ),
      ),
    );
    /* cSpell:enable */
  }

  /// Temporary implementation for testing purposes.
  SeedPhrase get _dummySeedPhrase => SeedPhrase.fromMnemonic(
        'few loyal swift champion rug peace dinosaur'
        ' erase bacon tone install universe',
      );

  /// Temporary implementation for testing purposes.
  LockFactor get _dummyUnlockFactor => const PasswordLockFactor('Test1234');
}
