import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.enums.swagger.dart';

extension AccountStatusDto on CatalystIDStatus {
  AccountStatus toModel() {
    switch (this) {
      // TODO(dtscalac): map it
      case CatalystIDStatus.swaggerGeneratedUnknown:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CatalystIDStatus.value_0:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CatalystIDStatus.value_1:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CatalystIDStatus.value_2:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CatalystIDStatus.value_3:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}