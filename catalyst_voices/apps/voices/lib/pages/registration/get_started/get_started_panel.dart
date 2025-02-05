import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_tile.dart';
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
          key: const Key('GetStartedMessage'),
          title: Text(context.l10n.accountCreationGetStartedTitle),
          subtitle: Text(context.l10n.accountCreationGetStatedDesc),
          spacing: 12,
          textColor: theme.colors.textOnPrimaryLevel1,
        ),
        const SizedBox(height: 32),
        Text(
          key: const Key('GetStartedQuestion'),
          context.l10n.accountCreationGetStatedWhatNext,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: CreateAccountType.values
                .map<Widget>((type) {
                  return RegistrationTile(
                    key: Key(type.toString()),
                    icon: type._icon,
                    title: type._getTitle(context.l10n),
                    subtitle: type._getSubtitle(context.l10n),
                    onTap: () {
                      switch (type) {
                        case CreateAccountType.createNew:
                          RegistrationCubit.of(context).createNewAccount();
                        case CreateAccountType.recover:
                          RegistrationCubit.of(context).recoverKeychain();
                      }
                    },
                  );
                })
                .separatedBy(const SizedBox(height: 12))
                .toList(),
          ),
        ),
      ],
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
