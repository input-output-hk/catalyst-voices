import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RestoredPanel extends StatelessWidget {
  const RestoredPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return RegistrationDetailsPanelScaffold(
      title: Text(
        key: const Key('RecoverySuccessTitle'),
        context.l10n.recoverySuccessTitle,
        style: textTheme.titleLarge?.copyWith(
          color: colors.textOnPrimaryLevel1,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            key: const Key('RecoverySuccessSubtitle'),
            context.l10n.recoverySuccessSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textOnPrimaryLevel0,
            ),
          ),
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VoicesFilledButton(
            key: const Key('RecoverySuccessGoToDashboardButton'),
            onTap: () => _redirectToDashboard(context),
            child: Text(context.l10n.recoverySuccessGoToDashboard),
          ),
          const SizedBox(height: 10),
          VoicesTextButton(
            key: const Key('RecoverySuccessGoAccountButton'),
            onTap: () => _redirectToMyAccount(context),
            child: Text(context.l10n.recoverySuccessGoAccount),
          ),
        ],
      ),
    );
  }

  void _redirectToDashboard(BuildContext context) {
    Navigator.of(context).pop();
    const DiscoveryRoute().go(context);
  }

  void _redirectToMyAccount(BuildContext context) {
    Navigator.of(context).pop();
    const AccountRoute().go(context);
  }
}
