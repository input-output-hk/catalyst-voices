import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

/// This exception is thrown when a resource conflict is detected, with localization support.
final class LocalizedResourceConflictException extends LocalizedException {
  final String? customMessage;

  const LocalizedResourceConflictException(this.customMessage);

  @override
  List<Object?> get props => [customMessage];

  @override
  String message(BuildContext context) => customMessage ?? context.l10n.resourceConflictError;
}
