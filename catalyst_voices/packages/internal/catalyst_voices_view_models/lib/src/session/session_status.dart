import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

enum SessionStatus {
  /// A user has a keychain and it is unlocked.
  actor,

  /// A user has a keychain but it is locked.
  guest,

  /// A user doesn't have a keychain.
  visitor;

  String name(VoicesLocalizations l10n) {
    return switch (this) {
      SessionStatus.actor => l10n.actor,
      SessionStatus.guest => l10n.guest,
      SessionStatus.visitor => l10n.visitor,
    };
  }
}
