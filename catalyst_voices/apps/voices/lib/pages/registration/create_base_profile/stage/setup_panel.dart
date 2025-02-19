import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SetupPanel extends StatelessWidget {
  const SetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const _Title(),
        Expanded(
          child: FocusScope(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: const [
                _DisplayNameSelector(),
                SizedBox(height: 24),
                _EmailSelector(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _IdeascaleInfoCard(),
        const SizedBox(height: 24),
        const _NavigationSelector(),
      ],
    );
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
      context.l10n.createBaseProfileSetupTitle,
      style: textStyle,
    );
  }
}

class _DisplayNameSelector extends StatelessWidget {
  const _DisplayNameSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<DisplayName>(
      selector: (state) => state.displayName,
      builder: (context, state) => _DisplayNameTextField(displayName: state),
    );
  }
}

class _DisplayNameTextField extends StatelessWidget {
  final DisplayName displayName;

  const _DisplayNameTextField({
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesDisplayNameTextField(
      key: const Key('DisplayNameTextField'),
      initialText: displayName.value,
      onChanged: (value) {
        RegistrationCubit.of(context)
            .baseProfile
            .updateDisplayName(DisplayName.dirty(value ?? ''));
      },
      onFieldSubmitted: null,
      decoration: VoicesTextFieldDecoration(
        labelText: l10n.createBaseProfileSetupDisplayNameLabel.starred(),
        hintText: l10n.createBaseProfileSetupDisplayNameHint,
        helperText: l10n.createBaseProfileSetupDisplayNameHelper,
        errorText: displayName.displayError?.message(context),
      ),
      maxLength: DisplayName.lengthRange.max,
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
        RegistrationCubit.of(context)
            .baseProfile
            .updateEmail(Email.dirty(value ?? ''));
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
        labelText: l10n.createBaseProfileSetupEmailLabel.starred(),
        hintText: l10n.createBaseProfileSetupEmailHint,
        helperText: l10n.createBaseProfileSetupEmailHelper,
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
        context.l10n.createBaseProfileSetupIdeascaleAccount,
        key: const Key('InfoCardTitle'),
      ),
      desc: BulletList(
        key: const Key('InfoCardDesc'),
        items: [
          context.l10n.createBaseProfileSetupIdeascaleReason1,
        ],
        spacing: 0,
      ),
      statusIcon: VoicesAssets.icons.informationCircle.buildIcon(),
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
