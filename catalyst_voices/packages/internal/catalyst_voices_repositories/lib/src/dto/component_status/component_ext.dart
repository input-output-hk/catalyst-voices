import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_status.swagger.dart' as swagger;

extension ComponentExt on swagger.Component {
  ComponentStatus toModel() {
    return ComponentStatus(
      name: name,
      isOperational: status == swagger.ComponentStatus.operational,
    );
  }
}
