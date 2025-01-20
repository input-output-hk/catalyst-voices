import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension DocumentPropertySchemaExt on DocumentPropertySchema {
  // TODO(dtscalac): convert to markdown
  String get formattedDescription {
    final string = description?.data;
    return (string ?? '').starred(isEnabled: isRequired);
  }
}
