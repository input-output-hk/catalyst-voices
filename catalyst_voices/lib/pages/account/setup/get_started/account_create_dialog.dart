import 'package:catalyst_voices/pages/account/setup/information_panel.dart';
import 'package:catalyst_voices/pages/account/setup/task_picture.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

enum AccountCreateType {
  createNew,
  recover;

  SvgGenImage get _icon => switch (this) {
        AccountCreateType.createNew => VoicesAssets.icons.colorSwatch,
        AccountCreateType.recover => VoicesAssets.icons.download,
      };

  String _getTitle(VoicesLocalizations l10n) => switch (this) {
        AccountCreateType.createNew => l10n.accountCreationCreate,
        AccountCreateType.recover => l10n.accountCreationRecover,
      };

  String _getSubtitle(VoicesLocalizations l10n) {
    return l10n.accountCreationOnThisDevice;
  }
}

class AccountCreateDialog extends StatelessWidget {
  const AccountCreateDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopPanelsDialog(
      left: InformationPanel(
        title: context.l10n.getStarted,
        picture: const TaskKeychainPicture(),
      ),
      right: const _RightPanel(),
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.accountCreationGetStartedTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.accountCreationGetStatedDesc,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          context.l10n.accountCreationGetStatedWhatNext,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 24),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: AccountCreateType.values
              .map<Widget>((type) {
                return _AccountCreateTypeTile(
                  key: ValueKey(type),
                  type: type,
                  onTap: () => Navigator.of(context).pop(type),
                );
              })
              .separatedBy(const SizedBox(height: 12))
              .toList(),
        ),
      ],
    );
  }
}

class _AccountCreateTypeTile extends StatelessWidget {
  final AccountCreateType type;
  final VoidCallback? onTap;

  const _AccountCreateTypeTile({
    super.key,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 80),
      child: Material(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                type._icon.buildIcon(
                  size: 48,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        type._getTitle(context.l10n),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        type._getSubtitle(context.l10n),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
