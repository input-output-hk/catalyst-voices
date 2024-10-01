import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/create_keychain_panel.dart';
import 'package:catalyst_voices/pages/registration/get_started/get_started_panel.dart';
import 'package:catalyst_voices/pages/registration/registration_info_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/wallet_link_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationDialog extends StatelessWidget {
  const RegistrationDialog._();

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/registration'),
      builder: (context) => const RegistrationDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Dependencies.instance.get<RegistrationCubit>(),
      child: BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) => _RegistrationDialog(state: state),
      ),
    );
  }
}

class _RegistrationDialog extends StatelessWidget {
  final RegistrationState state;

  const _RegistrationDialog({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTwoPaneDialog(
      left: const RegistrationInfoPanel(),
      right: switch (state) {
        GetStarted() => const GetStartedPanel(),
        FinishAccountCreation() => const Placeholder(),
        Recover() => const Placeholder(),
        CreateKeychain(:final stage, :final seedPhraseState) =>
          CreateKeychainPanel(
            stage: stage,
            seedPhraseState: seedPhraseState,
          ),
        WalletLink(:final stage, :final stateData) => WalletLinkPanel(
            stage: stage,
            stateData: stateData,
          ),
        AccountCompleted() => const Placeholder(),
      },
    );
  }
}
