import 'package:catalyst_voices_models/src/proposal/proposal_section.dart';
import 'package:equatable/equatable.dart';

final class ProposalTemplate extends Equatable {
  final List<ProposalSection> sections;

  const ProposalTemplate({
    required this.sections,
  });

  @override
  List<Object?> get props => [
        sections,
      ];
}
