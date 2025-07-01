import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class StreamUserObserver implements UserObserver {
  final _logger = Logger('StreamUserObserver');

  User _user;

  final _userSC = StreamController<User>.broadcast();
  bool _isActive = true;

  StreamUserObserver({
    User user = const User.empty(),
  }) : _user = user;

  @override
  bool get isActive => _isActive;

  @override
  set isActive(bool value) {
    if (_isActive != value) {
      _isActive = value;
      _user.activeAccount?.keychain.isActive = value;
    }
  }

  @override
  User get user => _user;

  @override
  set user(User newValue) {
    if (_user != newValue) {
      _logger.finest('Changing to $newValue');

      final oldKeychainId = _user.activeAccount?.keychain.id;
      final newKeychainId = newValue.activeAccount?.keychain.id;

      if (oldKeychainId != newKeychainId) {
        _user.activeAccount?.keychain.isActive = false;
        newValue.activeAccount?.keychain.isActive = _isActive;

        _logger.finest(
          'Active keychain changed '
          'from[$oldKeychainId] to[$newKeychainId]',
        );
      }

      _user = newValue;
      _userSC.add(newValue);
    }
  }

  @override
  Stream<User> get watchUser async* {
    yield _user;
    yield* _userSC.stream;
  }

  @override
  FutureOr<void> dispose() async {
    await _userSC.close();
  }
}

/// An interface that provides a streamable [User] to observe the current user.
/// 
/// The changes reflected in the stream might be related to the same user,
/// i.e. in case of profile change or the user might be completely different when another user logins.
abstract interface class UserObserver implements ActiveAware {
  User get user;

  set user(User newValue);

  Stream<User> get watchUser;

  FutureOr<void> dispose();
}
