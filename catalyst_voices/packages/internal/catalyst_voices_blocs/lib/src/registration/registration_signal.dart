import 'package:equatable/equatable.dart';

final class EmailAlreadyUsedSignal extends RegistrationSignal {
  const EmailAlreadyUsedSignal();
}

sealed class RegistrationSignal extends Equatable {
  const RegistrationSignal();

  @override
  List<Object?> get props => [];
}
