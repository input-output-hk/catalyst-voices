
import 'package:patrol_finders/patrol_finders.dart';

import '../types/registration_state.dart';



class OnboardingBuilder {
  final PatrolTester $;
  final RegistrationState targetState;

  // Additional parameters that you may want to set
  String? _password;

  OnboardingBuilder._(this.$, this.targetState);

  static OnboardingBuilder goTo(PatrolTester $, RegistrationState target) {
    return OnboardingBuilder._($, target);
  }