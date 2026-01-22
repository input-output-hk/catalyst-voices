import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class ContinueRegistration implements RegistrationType {
  const ContinueRegistration();
}

final class FreshRegistration implements RegistrationType {
  const FreshRegistration();
}

final class LinkDrepKey implements RegistrationType {
  final CatalystId id;

  const LinkDrepKey({required this.id});
}

final class RecoverRegistration implements RegistrationType {
  const RecoverRegistration();
}

sealed class RegistrationType {}

final class UpdateAccount implements RegistrationType {
  final CatalystId id;

  const UpdateAccount({required this.id});
}
