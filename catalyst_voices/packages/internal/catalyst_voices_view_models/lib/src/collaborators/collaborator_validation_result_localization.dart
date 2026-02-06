import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension CollaboratorValidationResultLocalization on CollaboratorValidationResult {
  String message(BuildContext context) {
    return switch (this) {
      MissingProposerRole() => context.l10n.contributorMissingProposerRole,
      NotProposerAndNotVerified() => context.l10n.contributorNotProposerAndNotVerified,
      NotVerifiedProfile() => context.l10n.contributorNotVerifiedProfile,
      ValidCollaborator() => '',
    };
  }
}
