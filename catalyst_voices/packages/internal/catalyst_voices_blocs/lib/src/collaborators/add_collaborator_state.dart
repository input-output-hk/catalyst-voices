import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class AddCollaboratorState extends Equatable {
  final bool isLoading;
  final CatalystId authorCatalystId;
  final Collaborators collaborators;
  final CollaboratorIdState collaboratorIdState;

  const AddCollaboratorState({
    this.isLoading = false,
    required this.authorCatalystId,
    required this.collaborators,
    required this.collaboratorIdState,
  });

  @override
  List<Object?> get props => [
    isLoading,
    authorCatalystId,
    collaborators,
    collaboratorIdState,
  ];

  AddCollaboratorState copyWith({
    CollaboratorIdState? collaboratorIdState,
  }) {
    return AddCollaboratorState(
      isLoading: isLoading,
      authorCatalystId: authorCatalystId,
      collaborators: collaborators,
      collaboratorIdState: collaboratorIdState ?? this.collaboratorIdState,
    );
  }
}

class CollaboratorIdState extends Equatable {
  final bool isLoading;
  final CollaboratorCatalystId collaboratorId;

  const CollaboratorIdState({this.isLoading = false, required this.collaboratorId});

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
