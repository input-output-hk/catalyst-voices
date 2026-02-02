import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/account/edit_roles_dialog.dart';
import 'package:catalyst_voices/pages/account/verification_required_dialog.dart';
import 'package:catalyst_voices/pages/registration/registration_dialog.dart';
import 'package:catalyst_voices/pages/registration/registration_type.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/cards/voices_instructions_with_steps_card.dart';
import 'package:catalyst_voices/widgets/text/published_on_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RepresentativeActionsInstructions extends StatelessWidget {
  const RepresentativeActionsInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RepresentativeActionCubit,
      RepresentativeActionState,
      IterableData<List<RepresentativeActionStep>>
    >(
      selector: (state) {
        return IterableData(state.representativeActions);
      },
      builder: (context, data) {
        final steps = data.value;
        return Offstage(
          offstage: steps.isEmpty,
          child: _RepresentativeActionsInstructions(
            steps: steps,
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final RepresentativeActionStep step;
  const _ActionButton(this.step);

  @override
  Widget build(BuildContext context) {
    final child = step.suffixIcon?.buildIcon(color: context.colors.iconsForeground);
    if (child == null) {
      return const SizedBox.shrink();
    }
    return VoicesIconButton(
      onTap: step.active ? () => _onTap(context) : null,
      child: child,
    );
  }

  Future<void> _onAddRepresentativeRoleTap(BuildContext context) async {
    final isVerified = context.read<AccountCubit>().state.accountPublicStatus.isVerified;
    if (!isVerified) {
      unawaited(VerificationRequiredDialog.show(context));
      return;
    }

    final confirmed = await EditRolesDialog.show(context);

    if (!confirmed || !context.mounted) {
      return;
    }

    final accountId = context.read<SessionCubit>().state.account?.catalystId;
    if (accountId == null) {
      return;
    }

    await RegistrationDialog.show(
      context,
      type: UpdateAccount(id: accountId),
    );
  }

  void _onTap(BuildContext context) {
    switch (step) {
      case RegistrationRepresentativeActionStep():
        unawaited(_onAddRepresentativeRoleTap(context));
        break;
      case StepBackRepresentativeActionStep():
        // TODO(LynxLynxx): Add logic
        break;
      case MissingRepresentativeProfileActionStep():
        // TODO(LynxLynxx): Add logic. Go to create representative profile page
        break;
      // ignore: unused_local_variable
      case ProfileRepresentativeActionStep(:final representativeDocumentId):
        // TODO(LynxLynxx): Add logic. Go to representative profile page
        break;
      default:
        break;
    }
  }
}

class _PrefixIcon extends StatelessWidget {
  final RepresentativeActionStep step;

  const _PrefixIcon(this.step);

  @override
  Widget build(BuildContext context) {
    return step.prefixIcon.buildIcon(color: context.colors.iconsBackground);
  }
}

class _RepresentativeActionsInstructions extends StatelessWidget {
  final List<RepresentativeActionStep> steps;

  const _RepresentativeActionsInstructions({
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesInstructionsWithStepsCard(
      title: Text(
        context.l10n.representativeActions,
        style: context.textTheme.titleSmall,
      ),
      steps: steps
          .map(
            (step) => InstructionStep(
              prefix: _PrefixIcon(step),
              prefixBackgroundColor: step.prefixBackgroundColor(context),
              child: _RepresentativeStepInstructions(step),
              suffix: _ActionButton(step),
              isActive: step.active,
            ),
          )
          .toList(),
    );
  }
}

class _RepresentativeStepInstructions extends StatelessWidget {
  final RepresentativeActionStep step;

  const _RepresentativeStepInstructions(this.step);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step.title(context),
          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        _Subtitle(step: step),
      ],
    );
  }
}

class _Subtitle extends StatelessWidget {
  final RepresentativeActionStep step;

  const _Subtitle({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 3,
      children: [
        if (step.hasIndicator)
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: context.colors.iconsError),
            width: 10,
            height: 10,
          ),
        if (step is ProfileRepresentativeActionStep)
          PublishedOnTimeText(
            dateTime: (step as ProfileRepresentativeActionStep).updatedAt,
            showTimezone: true,
          ),
        Text(step.subtitle(context)),
      ],
    );
  }
}

extension on RepresentativeActionStep {
  bool get hasIndicator {
    return switch (this) {
      RegistrationRepresentativeActionStep() || MissingRepresentativeProfileActionStep() => true,
      _ => false,
    };
  }

  SvgGenImage get prefixIcon {
    return switch (this) {
      RegistrationRepresentativeActionStep() => VoicesAssets.icons.key,
      _ => VoicesAssets.icons.userGroup,
    };
  }

  SvgGenImage? get suffixIcon {
    return switch (this) {
      SettingRepresentativeProfileLockActionStep() => null,
      _ => VoicesAssets.icons.chevronRight,
    };
  }

  Color prefixBackgroundColor(BuildContext context) {
    return switch (this) {
      StepBackRepresentativeActionStep() => context.colors.iconsError,
      SettingRepresentativeProfileLockActionStep() => context.colors.iconsDisabled,
      _ => context.colorScheme.primary,
    };
  }

  String subtitle(BuildContext context) {
    return switch (this) {
      RegistrationRepresentativeActionStep() => context.l10n.registerAsRepresentativeStepSubtitle,
      StepBackRepresentativeActionStep() => context.l10n.stepBackFromRepresentingSubtitle,
      MissingRepresentativeProfileActionStep() =>
        context.l10n.representativeProfileMissingStepSubtitle,
      ProfileRepresentativeActionStep() => context.l10n.viewNowRepresentativeProfile,
      SettingRepresentativeProfileLockActionStep() =>
        context.l10n.representativeProfileLockStepSubtitle,
    };
  }

  String title(BuildContext context) {
    return switch (this) {
      RegistrationRepresentativeActionStep() => context.l10n.registerAsRepresentativeStepTitle,
      StepBackRepresentativeActionStep() => context.l10n.stepBackFromRepresenting,
      ProfileRepresentativeActionStep() ||
      MissingRepresentativeProfileActionStep() ||
      SettingRepresentativeProfileLockActionStep() => context.l10n.representativeProfileStepTitle,
    };
  }
}
