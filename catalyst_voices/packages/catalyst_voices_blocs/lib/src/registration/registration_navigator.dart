import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';

// Note. Maybe make it non null and add hasNextStep / hasPreviousStep
/// Abstraction for navigation between different [RegistrationState] steps.
abstract interface class RegistrationNavigator<T extends RegistrationState> {
  /// Returns null if there is no next step.
  T? nextStep();

  /// Returns null if there is no previous step.
  T? previousStep();
}
