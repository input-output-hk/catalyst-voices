import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// [Account] can become public by attaching email to it. Emails is
/// sent to reviews api where it can be verified. You can think of this
/// as account status in reviews module.
///
/// [Account] have to verified to be able to publish Proposal for example.
///
/// Making [Account] public is optional.
enum AccountPublicStatus {
  verified,
  verifying,
  banned,
  notSetup,
  unknown;

  bool get isVerified => this == AccountPublicStatus.verified;
}
