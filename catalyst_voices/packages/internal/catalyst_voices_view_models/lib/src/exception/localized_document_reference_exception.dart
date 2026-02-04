import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/material.dart';

/// Exception thrown when a reference is invalid.
final class LocalizedDocumentReferenceException extends LocalizedException {
  const LocalizedDocumentReferenceException();

  @override
  String message(BuildContext context) => context.l10n.documentReferenceError;
}
