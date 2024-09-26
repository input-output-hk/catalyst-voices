import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Describes events that change the registration.
sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

final class CreateAccountTypeEvent extends RegistrationEvent {
  final CreateAccountType type;

  const CreateAccountTypeEvent({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

final class NextStepEvent extends RegistrationEvent {
  const NextStepEvent();

  @override
  List<Object?> get props => [];
}

final class PreviousStepEvent extends RegistrationEvent {
  const PreviousStepEvent();

  @override
  List<Object?> get props => [];
}
