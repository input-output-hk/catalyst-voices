import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_15_link_wallet_info.dart';

class WalletListPanel implements OnboardingPage {
  PatrolTester $;
  WalletListPanel(this.$);

  @override
  Future<void> goto() async {
    await LinkWalletInfoPanel($).goto();
    await LinkWalletInfoPanel($).clickChooseCardanoWallet();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}
