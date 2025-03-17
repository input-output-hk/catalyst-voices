import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_13_password_input.dart';

class KeychainFinalPanel extends OnboardingPageBase {
  KeychainFinalPanel(super.$);

  static const linkWalletAndRolesButton = Key('LinkWalletAndRolesButton');
  final keyLockedIcon = const Key('LockedPictureConstrainedBox');
  final checkedIcon = const Key('CheckedIcon');
  final stepTwoContainer = const Key('StepTwoContainer');
  final iconContainer = const Key('IconContainer');
  final lockedPictureConstrainedBox = const Key('LockedPictureConstrainedBox');
  Future<void> clickLinkWalletAndRoles() async {
    await $(linkWalletAndRolesButton).tap();
  }

  @override
  Future<void> goto() async {
    await PasswordInputPanel($).goto();
    await PasswordInputPanel($).enterPassword('Test1234', 'Test1234');
    await PasswordInputPanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      find.text('Base profile created', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('Catalyst Keychain created', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('Link Cardano Wallet & Roles', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('Catalyst account creation completed!', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text(
        'In the next step you write your Catalyst roles '
        'and \u2028account to the Cardano Mainnet.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect($(iconContainer), findsExactly(4));
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    // temporary: check for specific picture (green key locked icon)
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CatalystSvgPicture &&
            (widget.bytesLoader as dynamic).assetName ==
                'assets/images/keychain.svg',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CatalystSvgPicture &&
            (widget.bytesLoader as dynamic).assetName ==
                'assets/icons/lock-closed.svg',
      ),
      findsOneWidget,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }
}
