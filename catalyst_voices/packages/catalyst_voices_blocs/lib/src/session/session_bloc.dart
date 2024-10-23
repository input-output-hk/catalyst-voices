import 'package:catalyst_voices_blocs/src/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/session/session_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the user session.
final class SessionBloc extends Cubit<SessionState> with BlocErrorEmitterMixin {
  final UserService _userService;
  final RegistrationService _registrationService;

  final _logger = Logger('SessionBloc');

  bool _hasKeychain = false;
  bool _isUnlocked = false;
  Account? _account;

  final String _dummyKeychainId = 'TestUserKeychainID';
  static const LockFactor dummyUnlockFactor = PasswordLockFactor('Test1234');
  final _dummySeedPhrase = SeedPhrase.fromMnemonic(
    'few loyal swift champion rug peace dinosaur '
    'erase bacon tone install universe',
  );

  SessionBloc(
    this._userService,
    this._registrationService,
  ) : super(const VisitorSessionState()) {
    _userService.watchKeychain
        .map((keychain) => keychain != null)
        .distinct()
        .listen(_onHasKeychainChanged);

    _userService.watchKeychain
        .transform(KeychainToUnlockTransformer())
        .distinct()
        .listen(_onActiveKeychainUnlockChanged);

    _userService.watchAccount.listen(_onActiveAccountChanged);
  }

  Future<void> unlock(LockFactor lockFactor) async {
    await _userService.keychain!.unlock(lockFactor);
  }

  Future<void> lock() async {
    await _userService.keychain!.lock();
  }

  Future<void> removeKeychain() {
    return _userService.removeActiveAccount();
  }

  Future<void> switchToDummyAccount() async {
    final account = await _registrationService.registerTestAccount(
      keychainId: _dummyKeychainId,
      seedPhrase: _dummySeedPhrase,
      lockFactor: dummyUnlockFactor,
    );

    await _userService.switchTo(account: account);
  }

  void _onHasKeychainChanged(bool hasKeychain) {
    _logger.fine('Has keychain changed [$hasKeychain]');

    _hasKeychain = hasKeychain;
    _updateState();
  }

  void _onActiveKeychainUnlockChanged(bool isUnlocked) {
    _logger.fine('Keychain unlock changed [$isUnlocked]');

    _isUnlocked = isUnlocked;
    _updateState();
  }

  void _onActiveAccountChanged(Account? account) {
    _logger.fine('Active account changed [$account]');

    _account = account;
    _updateState();
  }

  void _updateState() {
    final hasKeychain = _hasKeychain;
    final isUnlocked = _isUnlocked;
    final account = _account;

    if (!hasKeychain) {
      emit(const VisitorSessionState());
      return;
    }

    if (!isUnlocked) {
      emit(const GuestSessionState());
      return;
    }

    emit(ActiveAccountSessionState(account: account));
  }
}
