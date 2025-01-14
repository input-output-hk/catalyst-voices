import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension DocumentPropertyExt on DocumentProperty {
  String get formattedDescription {
    return (schema.description ?? '').starred(isEnabled: schema.isRequired);
  }
}
