import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final List<Section> sections;

  const WorkspaceState({
    this.sections = const [],
  });

  WorkspaceState copyWith({
    List<Section>? sections,
  }) {
    return WorkspaceState(
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [
        sections,
      ];
}
