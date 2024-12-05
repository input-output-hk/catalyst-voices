import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalSection extends Equatable {
  final String id;
  final String name;
  final List<ProposalSectionStep> steps;

  const ProposalSection({
    required this.id,
    required this.name,
    required this.steps,
  });

  bool get isCompleted => steps.every((element) => element.hasAnswer);

  ProposalSection copyWith({
    String? id,
    String? name,
    List<ProposalSectionStep>? steps,
  }) {
    return ProposalSection(
      id: id ?? this.id,
      name: name ?? this.name,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        steps,
      ];
}

final class ProposalSectionStep extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<Guidance> guidances;
  final MarkdownString? answer;

  const ProposalSectionStep({
    required this.id,
    required this.name,
    this.description,
    this.guidances = const [],
    this.answer,
  });

  bool get hasAnswer => answer != null;

  ProposalSectionStep copyWith({
    String? id,
    String? name,
    Optional<String>? description,
    List<Guidance>? guidances,
    Optional<MarkdownString>? answer,
  }) {
    return ProposalSectionStep(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description.dataOr(this.description),
      guidances: guidances ?? this.guidances,
      answer: answer.dataOr(this.answer),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        guidances,
        answer,
      ];
}
