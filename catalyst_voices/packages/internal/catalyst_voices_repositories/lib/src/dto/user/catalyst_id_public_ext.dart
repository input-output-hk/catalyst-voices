import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.enums.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';

String? _tryDecodeUsername(dynamic source) {
  if (source is! String) {
    return null;
  }

  try {
    final encoded = Uri.encodeComponent(source);
    final decoded = Uri.decodeComponent(encoded);
    return decoded.replaceAll('%20', ' ');
  } catch (e) {
    return null;
  }
}

extension on CatalystIDStatus? {
  // inactive = 0
  // email_verified = 1
  // active = 2
  // banned = 3
  AccountPublicStatus toModel() {
    return switch (this) {
      null || CatalystIDStatus.swaggerGeneratedUnknown => AccountPublicStatus.unknown,
      CatalystIDStatus.value_0 => AccountPublicStatus.verifying,
      CatalystIDStatus.value_1 || CatalystIDStatus.value_2 => AccountPublicStatus.verified,
      CatalystIDStatus.value_3 => AccountPublicStatus.banned,
    };
  }
}

extension on CatalystRBACRegistrationStatus? {
  // initialized = 0
  // not_found = 1
  // volatile = 2
  // persistent = 3
  AccountPublicRbacStatus toModel() {
    return switch (this) {
      null ||
      CatalystRBACRegistrationStatus.swaggerGeneratedUnknown =>
        AccountPublicRbacStatus.unknown,
      CatalystRBACRegistrationStatus.value_0 => AccountPublicRbacStatus.initialized,
      CatalystRBACRegistrationStatus.value_1 => AccountPublicRbacStatus.notFound,
      CatalystRBACRegistrationStatus.value_2 => AccountPublicRbacStatus.volatile,
      CatalystRBACRegistrationStatus.value_3 => AccountPublicRbacStatus.persistent,
    };
  }
}

extension CatalystIdPublicExt on CatalystIDPublic {
  AccountPublicProfile toModel() {
    final email = this.email;
    final decodedEmail = email is String ? email : '';

    return AccountPublicProfile(
      email: decodedEmail,
      username: _tryDecodeUsername(username),
      status: status.toModel(),
      rbacRegStatus: rbacRegStatus.toModel(),
    );
  }
}
