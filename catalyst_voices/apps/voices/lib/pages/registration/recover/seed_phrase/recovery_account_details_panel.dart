import 'package:catalyst_voices/pages/registration/widgets/wallet_account_details.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RecoveryAccountDetailsPanel extends StatelessWidget {
  const RecoveryAccountDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return WalletAccountDetails(
      isNextButtonEnabledSelector: (state) => state.recoverStateData.isAccountSummaryNextEnabled,
      accountDetailsSelector: (state) => state.recoverStateData.accountDetails,
      onNextButtonTap: RegistrationCubit.of(context).nextStep,
      onBackButtonTap: () async {
        final cubit = RegistrationCubit.of(context);
        await cubit.recover.reset();
        cubit.previousStep();
      },
      onRetryButtonTap: () async {
        final recover = RegistrationCubit.of(context).recover;
        await recover.recoverAccount();
      },
      title: context.l10n.recoveryAccountTitle,
      successTitle: context.l10n.recoveryAccountSuccessTitle,
      nextButtonTitle: context.l10n.recoveryAccountDetailsAction,
      backButtonTitle: context.l10n.recoverDifferentKeychain,
    );
  }
}
