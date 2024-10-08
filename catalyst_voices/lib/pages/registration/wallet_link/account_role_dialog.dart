import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class AccountRoleDialog extends StatelessWidget {
  final AccountRole role;

  const AccountRoleDialog({
    required this.role,
    super.key,
  });

  static Future<void> show(BuildContext context, AccountRole role) async {
    return VoicesDialog.show<void>(
      context: context,
      builder: (context) {
        return AccountRoleDialog(
          role: role,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      constraints: const BoxConstraints(maxHeight: 460, maxWidth: 750),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                context.l10n.accountRoleDialogTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 310,
                child: Row(
                  children: [
                    _InfoContainer(
                      child: Column(
                        children: [
                          ClipOval(
                            child: CatalystImage.asset(
                              role.avatarPath,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role.getName(context),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            role.getVerboseName(context),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            role.getDescription(context),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _InfoContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.accountRoleDialogRoleSummaryTitle(
                              role.getName(context),
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ...role.getSummary(context).map(
                                (e) => Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: VoicesAssets.icons.check.buildIcon(
                                        color: Theme.of(context).colors.success,
                                      ),
                                    ),
                                    Text(
                                      e,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: VoicesFilledButton(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.accountRoleDialogButton),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoContainer extends StatelessWidget {
  const _InfoContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colors.outlineBorderVariant!,
          ),
        ),
        child: child,
      ),
    );
  }
}
