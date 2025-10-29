import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:equatable/equatable.dart';

class JoinedProposalBriefEntity extends Equatable {
  final DocumentEntityV2 proposal;
  final ProposalSubmissionAction? actionType;

  const JoinedProposalBriefEntity({
    required this.proposal,
    this.actionType,
  });

  @override
  List<Object?> get props => [
    proposal,
    actionType,
  ];
}
