import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum ActionsPageTab {
  all,
  approvals,
  role,
  external;

  const ActionsPageTab();

  String localizedEmptyStateDescription(BuildContext context) {
    return switch (this) {
      all => context.l10n.allActionsEmptyDescription,
      approvals => context.l10n.approvalsActionsEmptyDescription,
      role => context.l10n.roleActionsEmptyDescription,
      external => context.l10n.externalActionsEmptyDescription,
    };
  }

  String localizedEmptyStateTitle(BuildContext context) {
    return switch (this) {
      all => context.l10n.allActionsEmptyTitle,
      approvals => context.l10n.approvalsActionsEmptyTitle,
      role => context.l10n.roleActionsEmptyTitle,
      external => context.l10n.externalActionsEmptyTitle,
    };
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      all => context.l10n.all,
      approvals => context.l10n.approvals,
      role => context.l10n.role,
      external => context.l10n.external,
    };
  }
}
