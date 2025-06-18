import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SetupPanel extends StatefulWidget {
  const SetupPanel({super.key});

  @override
  State<SetupPanel> createState() => _SetupPanelState();
}

class _DisplayNameSelector extends StatelessWidget {
  const _DisplayNameSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<Username>(
      selector: (state) => state.username,
      builder: (context, state) => _DisplayNameTextField(displayName: state),
    );
  }
}

class _DisplayNameTextField extends StatelessWidget {
  final Username displayName;

  const _DisplayNameTextField({
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesUsernameTextField(
      key: const Key('DisplayNameTextField'),
      initialText: displayName.value,
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateUsername(Username.dirty(value ?? ''));
      },
      onFieldSubmitted: null,
      decoration: VoicesTextFieldDecoration(
        labelText: l10n.createProfileSetupDisplayNameLabel.starred(),
        hintText: l10n.createProfileSetupDisplayNameHint,
        helperText: l10n.createProfileSetupDisplayNameHelper,
        errorText: displayName.displayError?.message(context),
      ),
      maxLength: Username.lengthRange.max,
    );
  }
}

class _EmailSelector extends StatelessWidget {
  const _EmailSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<Email>(
      selector: (state) => state.email,
      builder: (context, state) => _EmailTextField(email: state),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  final Email email;

  const _EmailTextField({
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesEmailTextField(
      key: const Key('EmailTextField'),
      initialText: email.value,
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateEmail(Email.dirty(value ?? ''));
      },
      onFieldSubmitted: (value) {
        final email = Email.dirty(value);
        final cubit = RegistrationCubit.of(context);

        cubit.baseProfile.updateEmail(email);

        if (cubit.state.baseProfileStateData.isBaseProfileDataValid) {
          cubit.nextStep();
        }
      },
      textInputAction: TextInputAction.done,
      decoration: VoicesTextFieldDecoration(
        labelText: l10n.createProfileSetupEmailLabel.withSuffix(
          l10n.optional,
          space: true,
          brackets: true,
        ),
        hintText: l10n.createProfileSetupEmailHint,
        helperText: l10n.createProfileSetupEmailHelper,
        errorText: email.displayError?.message(context),
      ),
      maxLength: Email.lengthRange.max,
    );
  }
}

class _IdeascaleInfoCard extends StatelessWidget {
  const _IdeascaleInfoCard();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      key: const Key('IdeascaleInfoCard'),
      icon: VoicesAssets.icons.mailOpen.buildIcon(),
      title: Text(
        context.l10n.createProfileHasIdeascaleAccountAlready,
        key: const Key('InfoCardTitle'),
      ),
      desc: BulletList(
        key: const Key('InfoCardDesc'),
        items: [
          context.l10n.createProfileSetupIdeascaleReason1,
        ],
        spacing: 0,
      ),
      statusIcon: VoicesAssets.icons.informationCircle.buildIcon(),
    );
  }
}

class _Navigation extends StatelessWidget {
  final bool isNextEnabled;

  const _Navigation({
    required this.isNextEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return RegistrationBackNextNavigation(
      isNextEnabled: isNextEnabled,
    );
  }
}

class _NavigationSelector extends StatelessWidget {
  const _NavigationSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.isBaseProfileDataValid,
      builder: (context, state) => _Navigation(isNextEnabled: state),
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
              _DisplayNameSelector(),
              SizedBox(height: 24),
              _EmailSelector(),
            ],
          ),
        ),
      ),
      footer: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _IdeascaleInfoCard(),
          SizedBox(height: 24),
          _NavigationSelector(),
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
