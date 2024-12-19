import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderState extends Equatable {
  final List<Section> sections;
  final ProposalGuidance guidance;

  const ProposalBuilderState({
    this.sections = const [],
    this.guidance = const ProposalGuidance(),
  });

  ProposalBuilderState copyWith({
    List<Section>? sections,
    ProposalGuidance? guidance,
  }) {
    return ProposalBuilderState(
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

final class ProposalGuidance extends Equatable {
  final bool isNoneSelected;
  final List<Guidance> guidances;

  const ProposalGuidance({
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
