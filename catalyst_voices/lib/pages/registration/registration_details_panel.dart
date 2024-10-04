import 'package:catalyst_voices/pages/registration/create_keychain/create_keychain_panel.dart';
import 'package:catalyst_voices/pages/registration/finish_account/finish_account_creation_panel.dart';
import 'package:catalyst_voices/pages/registration/get_started/get_started_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/wallet_link_panel.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationDetailsPanel extends StatelessWidget {
  const RegistrationDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationCubit, RegistrationState, RegistrationStep>(
      selector: (state) => state.step,
      builder: (context, state) {
        return switch (state) {
          GetStartedStep() => const GetStartedPanel(),
          RecoverStep() => const Placeholder(),
          CreateKeychainStep(:final stage) => CreateKeychainPanel(stage: stage),
          FinishAccountCreationStep() => const FinishAccountCreationPanel(),
          WalletLinkStep(:final stage) => WalletLinkPanel(stage: stage),
          AccountCompletedStep() => const Placeholder(),
        };
      },
    );
  }
}
