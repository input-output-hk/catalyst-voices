import 'package:catalyst_voices/pages/registration/widgets/registration_tile.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class RecoverMethodPanel extends StatelessWidget {
  const RecoverMethodPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorLvl0 = theme.colors.textOnPrimaryLevel0;
    final colorLvl1 = theme.colors.textOnPrimaryLevel1;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            context.l10n.recoverKeychainMethodsTitle,
            style: theme.textTheme.titleMedium?.copyWith(color: colorLvl1),
          ),
          const SizedBox(height: 12),
          AffixDecorator(
            iconTheme: IconThemeData(
              size: 24,
              color: colorLvl1,
            ),
            prefix: VoicesAssets.icons.exclamation.buildIcon(),
            child: Text(
              context.l10n.recoverKeychainMethodsNoKeychainFound,
              style: theme.textTheme.titleSmall?.copyWith(color: colorLvl1),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.recoverKeychainMethodsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: colorLvl1),
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.recoverKeychainMethodsListTitle,
            style: theme.textTheme.titleSmall?.copyWith(color: colorLvl0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: RegistrationRecoverMethod.values
                  .map<Widget>(
                    (method) {
                      return RegistrationTile(
                        key: ValueKey(method),
                        icon: method._icon,
                        title: method._getTitle(context.l10n),
                        subtitle: method._getSubtitle(context.l10n),
                        onTap: () {
                          //
                        },
                      );
                    },
                  )
                  .separatedBy(const SizedBox(height: 12))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

extension _RegistrationRecoverMethodExt on RegistrationRecoverMethod {
  SvgGenImage get _icon => switch (this) {
        RegistrationRecoverMethod.seedPhrase => VoicesAssets.icons.colorSwatch,
      };

  String _getTitle(VoicesLocalizations l10n) => switch (this) {
        RegistrationRecoverMethod.seedPhrase => l10n.seedPhrase12Words,
      };

  String? _getSubtitle(VoicesLocalizations l10n) => switch (this) {
        RegistrationRecoverMethod.seedPhrase => null,
      };
}
