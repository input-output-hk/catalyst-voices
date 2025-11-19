import 'package:equatable/equatable.dart';

sealed class AddCollaboratorSignal extends Equatable {
  const AddCollaboratorSignal();

  @override
  List<Object?> get props => [];
}

final class ValidCollaboratorIdSignal extends AddCollaboratorSignal {
  const ValidCollaboratorIdSignal();
}
