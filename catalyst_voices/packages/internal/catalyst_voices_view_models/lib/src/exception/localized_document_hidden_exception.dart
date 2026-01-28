import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/material.dart';

/// Exception thrown when a document is hidden and should not be accessed.
final class LocalizedDocumentHiddenException extends LocalizedException {
  const LocalizedDocumentHiddenException();

  @override
  String message(BuildContext context) => context.l10n.documentHiddenException;
}
