import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

extension StringDisplayNameExt on String? {
  String asDisplayName(BuildContext context) {
    final value = this;
    if (value == null || value.isBlank) return context.l10n.anonymousUsername;
    return value;
  }
}
