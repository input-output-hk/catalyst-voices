import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class GetStartedPanel extends StatelessWidget {
  const GetStartedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: Text(context.l10n.accountCreationGetStartedTitle),
          subtitle: Text(context.l10n.accountCreationGetStatedDesc),
          spacing: 12,
          textColor: theme.colors.textOnPrimaryLevel1,
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
          children: CreateAccountType.values
              .map<Widget>((type) {
                return _CreateAccountTypeTile(
                  key: ValueKey(type),
                  type: type,
                  onTap: () {
                    switch (type) {
                      case CreateAccountType.createNew:
                        RegistrationCubit.of(context).createNewKeychainStep();
                      case CreateAccountType.recover:
                        RegistrationCubit.of(context).recoverKeychainStep();
                    }
                  },
                );
              })
              .separatedBy(const SizedBox(height: 12))
              .toList(),
        ),
      ],
    );
  }
}

class _CreateAccountTypeTile extends StatelessWidget {
  final CreateAccountType type;
  final VoidCallback? onTap;

  const _CreateAccountTypeTile({
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

extension _CreateAccountTypeExt on CreateAccountType {
  SvgGenImage get _icon => switch (this) {
        CreateAccountType.createNew => VoicesAssets.icons.colorSwatch,
        CreateAccountType.recover => VoicesAssets.icons.download,
      };

  String _getTitle(VoicesLocalizations l10n) => switch (this) {
        CreateAccountType.createNew => l10n.accountCreationCreate,
        CreateAccountType.recover => l10n.accountCreationRecover,
      };

  String _getSubtitle(VoicesLocalizations l10n) {
    return l10n.accountCreationOnThisDevice;
  }
}
