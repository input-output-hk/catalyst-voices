import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_public.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_status.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_rbac_registration_status.dart';

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

extension on CatalystIdStatus? {
  AccountPublicStatus toModel() {
    return switch (this) {
      null => AccountPublicStatus.unknown,
      CatalystIdStatus.inactive => AccountPublicStatus.verifying,
      CatalystIdStatus.emailVerified || CatalystIdStatus.active => AccountPublicStatus.verified,
      CatalystIdStatus.banned => AccountPublicStatus.banned,
    };
  }
}

extension on CatalystRbacRegistrationStatus? {
  AccountPublicRbacStatus toModel() {
    return switch (this) {
      null => AccountPublicRbacStatus.unknown,
      CatalystRbacRegistrationStatus.initialized => AccountPublicRbacStatus.initialized,
      CatalystRbacRegistrationStatus.notFound => AccountPublicRbacStatus.notFound,
      CatalystRbacRegistrationStatus.volatile => AccountPublicRbacStatus.volatile,
      CatalystRbacRegistrationStatus.persistent => AccountPublicRbacStatus.persistent,
    };
  }
}

extension CatalystIdPublicExt on CatalystIdPublic {
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
