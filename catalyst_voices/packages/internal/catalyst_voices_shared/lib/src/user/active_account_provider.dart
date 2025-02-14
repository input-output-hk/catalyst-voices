import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Exposes only active user methods.
abstract interface class ActiveAccountProvider {
  /// Currently used [account]. Null when guest mode or locked.
  Account? get account;

  /// Emits changes when active account is changed.
  Stream<Account?> get watchAccount;
}
