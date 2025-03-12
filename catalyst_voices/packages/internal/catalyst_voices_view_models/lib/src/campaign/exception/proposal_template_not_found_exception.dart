import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class ProposalTemplateNotFoundException extends LocalizedException {
  const ProposalTemplateNotFoundException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorProposalTemplateNotFound;
  }
}
