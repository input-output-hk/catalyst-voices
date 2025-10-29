import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:equatable/equatable.dart';

class JoinedProposalBriefEntity extends Equatable {
  final DocumentEntityV2 proposal;
  final ProposalSubmissionAction? actionType;
  final List<String> versionIds;

  const JoinedProposalBriefEntity({
    required this.proposal,
    this.actionType,
    required this.versionIds,
  });

  @override
  List<Object?> get props => [
    proposal,
    actionType,
    versionIds,
  ];
}
