import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum ActionsPageTab {
  all,
  approvals,
  role,
  external;

  const ActionsPageTab();

  String localizedName(BuildContext context) {
    switch (this) {
      case ActionsPageTab.all:
        return context.l10n.all;
      case ActionsPageTab.approvals:
        return context.l10n.approvals;
      case ActionsPageTab.role:
        return context.l10n.role;
      case ActionsPageTab.external:
        return context.l10n.external;
    }
  }
}
