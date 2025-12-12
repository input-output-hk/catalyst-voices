import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension CatalystIdExt on CatalystId {
  String getDisplayName(BuildContext context) {
    final catalystId = this;
    if (catalystId.isAnonymous) {
      return context.l10n.anonymousUsername;
    }
    return catalystId.username!;
  }
}
