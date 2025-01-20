import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/privacy_policy_rich_text.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/tos_rich_text.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AcknowledgementsPanel extends StatelessWidget {
  const AcknowledgementsPanel({super.key});

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
                _TosCheckboxSelector(key: ValueKey('TosCheckbox')),
                SizedBox(height: 24),
                _PrivacyPolicySelector(key: ValueKey('PrivacyPolicyCheckbox')),
                SizedBox(height: 24),
                _DataUsageSelector(key: ValueKey('DataUsageCheckbox')),
              ],
            ),
          ),
        ),
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
      context.l10n.createBaseProfileAcknowledgementsTitle,
      style: textStyle,
    );
  }
}

class _TosCheckboxSelector extends StatelessWidget {
  const _TosCheckboxSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.isToSAccepted,
      builder: (context, state) => _TosCheckbox(isChecked: state),
    );
  }
}

class _TosCheckbox extends StatelessWidget {
  final bool isChecked;

  const _TosCheckbox({
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: isChecked,
      label: const TosRichText(),
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateToS(isAccepted: value);
      },
    );
  }
}

class _PrivacyPolicySelector extends StatelessWidget {
  const _PrivacyPolicySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.isPrivacyPolicyAccepted,
      builder: (context, state) => _PrivacyPolicyCheckBox(isChecked: state),
    );
  }
}

class _PrivacyPolicyCheckBox extends StatelessWidget {
  final bool isChecked;

  const _PrivacyPolicyCheckBox({
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: isChecked,
      label: const PrivacyPolicyRichText(),
      onChanged: (value) {
        RegistrationCubit.of(context)
            .baseProfile
            .updatePrivacyPolicy(isAccepted: value);
      },
    );
  }
}

class _DataUsageSelector extends StatelessWidget {
  const _DataUsageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.isDataUsageAccepted,
      builder: (context, state) => _DataUsageCheckBox(isChecked: state),
    );
  }
}

class _DataUsageCheckBox extends StatelessWidget {
  final bool isChecked;

  const _DataUsageCheckBox({
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: isChecked,
      label: Text(context.l10n.createBaseProfileAcknowledgementsDataUsage),
      onChanged: (value) {
        RegistrationCubit.of(context)
            .baseProfile
            .updateDataUsage(isAccepted: value);
      },
    );
  }
}

class _NavigationSelector extends StatelessWidget {
  const _NavigationSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.arAcknowledgementsAccepted,
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
