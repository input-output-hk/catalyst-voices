import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

/// Localized exception thrown when a proposal's deletion fails.
final class LocalizedProposalDeletionException extends LocalizedException {
  const LocalizedProposalDeletionException();

  @override
  String message(BuildContext context) => context.l10n.errorProposalDeleted;
}
