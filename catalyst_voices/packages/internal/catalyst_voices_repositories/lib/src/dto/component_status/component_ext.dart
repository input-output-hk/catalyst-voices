import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/models/component.dart';
import 'package:catalyst_voices_repositories/src/api/models/component_status.dart' as api_enum;

extension ComponentExt on Component {
  ComponentStatus toModel() {
    return ComponentStatus(
      name: name,
      isOperational: status == api_enum.ComponentStatus.operational,
    );
  }
}
