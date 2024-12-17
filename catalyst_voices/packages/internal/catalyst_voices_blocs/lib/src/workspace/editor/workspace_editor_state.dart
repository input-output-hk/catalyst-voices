import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceEditorState extends Equatable {
  final List<Section> sections;
  final WorkspaceGuidance guidance;

  const WorkspaceEditorState({
    this.sections = const [],
    this.guidance = const WorkspaceGuidance(),
  });

  WorkspaceEditorState copyWith({
    List<Section>? sections,
    WorkspaceGuidance? guidance,
  }) {
    return WorkspaceEditorState(
      sections: sections ?? this.sections,
      guidance: guidance ?? this.guidance,
    );
  }

  @override
  List<Object?> get props => [
        sections,
        guidance,
      ];
}

final class WorkspaceGuidance extends Equatable {
  final bool isNoneSelected;
  final List<Guidance> guidances;

  const WorkspaceGuidance({
    this.isNoneSelected = false,
    this.guidances = const [],
  });

  bool get showEmptyState => !isNoneSelected && guidances.isEmpty;

  @override
  List<Object?> get props => [
        isNoneSelected,
        guidances,
      ];
}
