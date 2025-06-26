import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/display_name_text_field.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/email_text_field.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/receive_emails_checkbox.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/setup_panel_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SetupPanel extends StatefulWidget {
  const SetupPanel({super.key});

  @override
  State<SetupPanel> createState() => _SetupPanelState();
}

class _EmailInfoCard extends StatelessWidget {
  const _EmailInfoCard();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      key: const Key('EmailInfoCard'),
      icon: VoicesAssets.icons.mailOpen.buildIcon(),
      desc: BulletList(
        key: const Key('InfoCardDesc'),
        items: [
          context.l10n.createProfileSetupEmailReason1,
          context.l10n.createProfileSetupEmailReason2,
          context.l10n.createProfileSetupEmailReason3,
        ],
        spacing: 0,
      ),
      statusIcon: VoicesAssets.icons.informationCircle.buildIcon(),
    );
  }
}

class _SetupPanelState extends State<SetupPanel> {
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      title: const _Title(),
      body: FocusScope(
        child: VoicesScrollbar(
          controller: _scrollController,
          alwaysVisible: true,
          padding: const EdgeInsets.only(left: 10),
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: const [
              DisplayNameTextField(),
              SizedBox(height: 24),
              EmailTextField(),
              SizedBox(height: 20),
              ReceiveEmailsCheckbox(),
            ],
          ),
        ),
      ),
      footer: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailInfoCard(),
          SizedBox(height: 24),
          SetupPanelNavigation(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final textStyle = (textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimaryLevel1,
    );

    return Text(
      key: const Key('TitleText'),
      context.l10n.createProfileSetupTitle,
      style: textStyle,
    );
  }
}
