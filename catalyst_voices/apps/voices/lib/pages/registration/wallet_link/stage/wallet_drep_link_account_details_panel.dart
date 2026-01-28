import 'package:catalyst_voices/pages/registration/widgets/wallet_account_details.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class WalletDrepLinkAccountDetailsPanel extends StatelessWidget {
  const WalletDrepLinkAccountDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return WalletAccountDetails(
      isNextButtonEnabledSelector: (state) =>
          state.walletDrepLinkAccountDetails?.isSuccess ?? false,
      accountDetailsSelector: (state) => state.walletDrepLinkAccountDetails,
      onNextButtonTap: RegistrationCubit.of(context).nextStep,
      onBackButtonTap: RegistrationCubit.of(context).drepLinkChooseOtherWallet,
      onRetryButtonTap: RegistrationCubit.of(context).drepLinkChooseOtherWallet,
      title: context.l10n.walletAccountDetailsTitle,
      successTitle: context.l10n.keychainFound,
      nextButtonTitle: context.l10n.drepLinkAccountDetailsAction,
      backButtonTitle: context.l10n.chooseOtherWallet,
    );
  }
}
