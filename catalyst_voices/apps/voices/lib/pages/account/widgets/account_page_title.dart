import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AccountPageTitle extends StatelessWidget {
  const AccountPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NavigationBack(),
        const SizedBox(height: 16),
        Text(
          context.l10n.myAccount,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key: const Key('ProfileAndKeychainText'),
              context.l10n.profileAndKeychain,
              style: context.textTheme.displaySmall?.copyWith(color: context.colorScheme.primary),
            ),
            VoicesLearnMoreTextButton.url(url: VoicesConstants.myAccountUrl),
          ],
        ),
      ],
    );
  }
}
