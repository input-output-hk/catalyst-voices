import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Describes events that change the registration.
sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

final class RebuildStateEvent extends RegistrationEvent {
  const RebuildStateEvent();

  @override
  List<Object?> get props => [];
}

sealed class RegistrationNavigationEvent extends RegistrationEvent {
  const RegistrationNavigationEvent();
}

final class CreateAccountTypeEvent extends RegistrationNavigationEvent {
  final CreateAccountType type;

  const CreateAccountTypeEvent({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

final class NextStepEvent extends RegistrationNavigationEvent {
  const NextStepEvent();

  @override
  List<Object?> get props => [];
}

final class PreviousStepEvent extends RegistrationNavigationEvent {
  const PreviousStepEvent();

  @override
  List<Object?> get props => [];
}
