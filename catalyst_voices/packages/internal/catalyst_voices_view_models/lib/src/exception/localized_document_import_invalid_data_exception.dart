import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart' show BuildContext;

/// Exception thrown when a document import fails due to invalid data.
final class LocalizedDocumentImportInvalidDataException extends LocalizedException {
  const LocalizedDocumentImportInvalidDataException();

  @override
  String message(BuildContext context) => context.l10n.documentImportInvalidDataError;
}
