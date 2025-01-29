import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension DocumentPropertySchemaExt on DocumentPropertySchema {
  String get formattedTitle {
    return title.starred(isEnabled: isRequired);
  }
}
