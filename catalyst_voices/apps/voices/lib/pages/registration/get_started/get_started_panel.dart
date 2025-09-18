import 'dart:async';

import 'package:catalyst_voices/pages/registration/get_started/create_account_methods.dart';
import 'package:catalyst_voices/pages/registration/no_wallet_found_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
          child: CreateAccountMethods(
            onTap: (value) {
              unawaited(_onCreateAccountTypeSelected(context, type: value));
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleCreateNewAccount(BuildContext context) async {
    final hasWallets = await context.read<SessionCubit>().checkAvailableWallets();

    if (hasWallets && context.mounted) {
      RegistrationCubit.of(context).createNewAccount();
      return;
    }

    if (!context.mounted) return;
    final canRegister = await NoWalletFoundDialog.show(context);

    if (canRegister && context.mounted) {
      RegistrationCubit.of(context).createNewAccount();
    }
  }

  Future<void> _onCreateAccountTypeSelected(
    BuildContext context, {
    required CreateAccountType type,
  }) async {
    switch (type) {
      case CreateAccountType.createNew:
        await _handleCreateNewAccount(context);
      case CreateAccountType.recover:
        RegistrationCubit.of(context).recoverKeychain();
    }
  }
}
