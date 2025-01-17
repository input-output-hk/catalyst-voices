import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

part 'account_create_step.dart';
part 'account_recover_step.dart';

/// Represents only step of registration, not stage of this step.
sealed class RegistrationStep extends Equatable {
  const RegistrationStep();

  // TODO(damian-molinski): do it with casting type check
  bool get isRegistrationFlow => false;

  // TODO(damian-molinski): do it with casting type check
  bool get isRecoverFlow => false;

  @override
  List<Object?> get props => [];
}

final class GetStartedStep extends RegistrationStep {
  const GetStartedStep();
}
