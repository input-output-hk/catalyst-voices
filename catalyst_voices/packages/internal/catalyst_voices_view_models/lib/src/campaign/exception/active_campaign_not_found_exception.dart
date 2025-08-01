import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Exception thrown when an active campaign cannot be found, with localization support.
///
/// This exception is thrown when the user tries to access a campaign that is not active.
final class ActiveCampaignNotFoundException extends LocalizedException {
  const ActiveCampaignNotFoundException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorNoActiveCampaignFound;
  }
}
