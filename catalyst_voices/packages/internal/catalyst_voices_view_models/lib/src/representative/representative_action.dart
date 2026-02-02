import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/representative/representative_action_steps_view_model.dart';
import 'package:catalyst_voices_view_models/src/representative/representative_registration_status.dart';
import 'package:equatable/equatable.dart';

/// User needs to set up their representative profile.
class MissingRepresentativeProfileActionStep extends RepresentativeActionStep {
  const MissingRepresentativeProfileActionStep({super.active = true});
}

/// User has set up their representative profile can edit it.
class ProfileRepresentativeActionStep extends RepresentativeActionStep {
  final DocumentRef representativeDocumentId;

  const ProfileRepresentativeActionStep({
    super.active = true,
    required this.representativeDocumentId,
  });

  @override
  List<Object?> get props => [...super.props, representativeDocumentId];

  DateTime get updatedAt =>
      representativeDocumentId.ver?.dateTime ?? representativeDocumentId.id.dateTime;
}

/// User needs to register as representative.
class RegistrationRepresentativeActionStep extends RepresentativeActionStep {
  const RegistrationRepresentativeActionStep({
    required super.active,
  });
}

sealed class RepresentativeActionStep extends Equatable {
  final bool active;

  const RepresentativeActionStep({
    required this.active,
  });

  @override
  List<Object?> get props => [active];

  static RepresentativeActionStepsViewModel steps({
    required RepresentativeRegistrationStatus registrationStatus,
    DocumentRef? representativeDocumentId,
  }) {
    final isRepresentativeProfileSet = representativeDocumentId != null;

    final registrationStep = !isRepresentativeProfileSet
        ? RegistrationRepresentativeActionStep(active: !registrationStatus.isRegistered)
        : null;

    final profileStep = switch (registrationStatus) {
      RepresentativeRegistrationStatus.notRegistered =>
        const SettingRepresentativeProfileLockActionStep(),
      RepresentativeRegistrationStatus.registered when isRepresentativeProfileSet =>
        ProfileRepresentativeActionStep(
          representativeDocumentId: representativeDocumentId,
        ),
      RepresentativeRegistrationStatus.registered => const MissingRepresentativeProfileActionStep(),
    };

    final stepBackStep = switch (registrationStatus) {
      RepresentativeRegistrationStatus.notRegistered => null,
      RepresentativeRegistrationStatus.registered => const StepBackRepresentativeActionStep(),
    };

    return RepresentativeActionStepsViewModel(
      representativeActions: [
        ?registrationStep,
        profileStep,
      ],
      additionalStep: stepBackStep,
    );
  }
}

/// User can't edit or setup representative profile as previous step was not completed.
class SettingRepresentativeProfileLockActionStep extends RepresentativeActionStep {
  const SettingRepresentativeProfileLockActionStep({super.active = false});
}

/// User can step back from Representative action.
class StepBackRepresentativeActionStep extends RepresentativeActionStep {
  const StepBackRepresentativeActionStep({super.active = true});
}
