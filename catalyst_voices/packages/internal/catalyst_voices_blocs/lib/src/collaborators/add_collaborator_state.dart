import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class AddCollaboratorState extends Equatable {
  final CatalystId? authorCatalystId;
  final CollaboratorsIds collaborators;
  final CollaboratorIdState collaboratorIdState;

  const AddCollaboratorState({
    this.authorCatalystId,
    this.collaborators = const CollaboratorsIds(),
    this.collaboratorIdState = const CollaboratorIdState(),
  });

  @override
  List<Object?> get props => [
    authorCatalystId,
    collaborators,
    collaboratorIdState,
  ];

  AddCollaboratorState copyWith({
    CollaboratorIdState? collaboratorIdState,
  }) {
    return AddCollaboratorState(
      authorCatalystId: authorCatalystId,
      collaborators: collaborators,
      collaboratorIdState: collaboratorIdState ?? this.collaboratorIdState,
    );
  }
}

class CollaboratorIdState extends Equatable {
  final bool isLoading;
  final CollaboratorCatalystId collaboratorId;

  const CollaboratorIdState({
    this.isLoading = false,
    this.collaboratorId = const CollaboratorCatalystId.pure(),
  });

  bool get isValid => collaboratorId.isValid && !collaboratorId.isPure;

  @override
  List<Object?> get props => [isLoading, collaboratorId];

  CollaboratorIdState copyWith({
    bool? isLoading,
    CollaboratorCatalystId? collaboratorId,
  }) {
    return CollaboratorIdState(
      isLoading: isLoading ?? this.isLoading,
      collaboratorId: collaboratorId ?? this.collaboratorId,
    );
  }
}
