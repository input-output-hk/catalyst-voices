import 'package:catalyst_voices/pages/account/creation/create_keychain/create_keychain_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SplashPanel extends StatelessWidget {
  const SplashPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.accountCreationSplashTitle,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.accountCreationSplashMessage,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        const Spacer(),
        VoicesFilledButton(
          child: Text(context.l10n.accountCreationSplashNextButton),
          onTap: () {
            CreateKeychainController.of(context).goToNextStage();
          },
        ),
      ],
    );
  }
}
