import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.enums.swagger.dart';

extension NullableCatalystIDStatusExt on CatalystIDStatus? {
  // inactive = 0
  // email_verified = 1
  // active = 2
  // banned = 3
  AccountPublicStatus toModel() {
    return switch (this) {
      null ||
      CatalystIDStatus.swaggerGeneratedUnknown =>
        AccountPublicStatus.unknown,
      CatalystIDStatus.value_0 => AccountPublicStatus.verifying,
      CatalystIDStatus.value_1 ||
      CatalystIDStatus.value_2 =>
        AccountPublicStatus.verified,
      CatalystIDStatus.value_3 => AccountPublicStatus.banned,
    };
  }
}
