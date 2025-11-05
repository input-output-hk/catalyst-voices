import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class JoinedProposalBriefData extends Equatable {
  final DocumentData proposal;
  final DocumentData? template;
  final ProposalSubmissionAction? actionType;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;

  const JoinedProposalBriefData({
    required this.proposal,
    this.template,
    this.actionType,
    this.versionIds = const [],
    this.commentsCount = 0,
    this.isFavorite = false,
  });

  bool get isFinal => actionType == ProposalSubmissionAction.aFinal;

  int get iteration => versionIds.indexOf(proposal.metadata.version) + 1;

  @override
  List<Object?> get props => [
    proposal,
    template,
    actionType,
    versionIds,
    commentsCount,
    isFavorite,
  ];
}
