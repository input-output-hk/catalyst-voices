import 'package:catalyst_voices_models/src/proposal/proposal_section.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilder extends Equatable {
  final List<ProposalSection> sections;

  const ProposalBuilder({
    required this.sections,
  });

  bool get isValid => sections.every((element) => element.isCompleted);

  ProposalBuilder copyWith({
    List<ProposalSection>? sections,
  }) {
    return ProposalBuilder(
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [
        sections,
      ];
}
