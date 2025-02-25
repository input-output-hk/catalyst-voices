import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

extension DocumentPropertySchemaExt on DocumentPropertySchema {
  String get formattedTitle {
    return title.starred(isEnabled: isRequired);
  }
}
