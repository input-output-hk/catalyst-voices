import 'package:catalyst_voices_models/src/proposal/proposal.dart';
import 'package:catalyst_voices_models/src/proposal/proposal_template.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilder extends Equatable {
  const ProposalBuilder();

  // ignore: avoid_unused_constructor_parameters
  const ProposalBuilder.fromTemplate(ProposalTemplate template) : this();

  // ignore: avoid_unused_constructor_parameters
  const ProposalBuilder.fromProposal(Proposal proposal) : this();

  bool get isValid => false;

  Proposal build() {
    throw UnimplementedError();
  }

  ProposalBuilder copyWith() {
    return const ProposalBuilder();
  }

  @override
  List<Object?> get props => [];
}
