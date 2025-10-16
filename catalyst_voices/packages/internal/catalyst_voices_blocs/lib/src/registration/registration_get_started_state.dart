import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationGetStartedState extends Equatable {
  final List<CreateAccountType> availableMethods;

  const RegistrationGetStartedState({
    this.availableMethods = const [],
  });

  @override
  List<Object?> get props => [availableMethods];

  RegistrationGetStartedState copyWith({
    List<CreateAccountType>? availableMethods,
  }) {
    return RegistrationGetStartedState(
      availableMethods: availableMethods ?? this.availableMethods,
    );
  }
}
