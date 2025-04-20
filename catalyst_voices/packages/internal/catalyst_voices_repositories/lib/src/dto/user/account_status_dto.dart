import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.enums.swagger.dart';

extension CatalystIDStatusExt on CatalystIDStatus {
  AccountStatus toModel() {
    switch (this) {
      case CatalystIDStatus.swaggerGeneratedUnknown:
        // TODO(dtscalac): map it when AccountStatus is defined
        throw UnimplementedError();
      case CatalystIDStatus.value_0:
        // TODO(dtscalac): map it when AccountStatus is defined
        throw UnimplementedError();
      case CatalystIDStatus.value_1:
        // TODO(dtscalac): map it when AccountStatus is defined
        throw UnimplementedError();
      case CatalystIDStatus.value_2:
        // TODO(dtscalac): map it when AccountStatus is defined
        throw UnimplementedError();
      case CatalystIDStatus.value_3:
        // TODO(dtscalac): map it when AccountStatus is defined
        throw UnimplementedError();
    }
  }
}
