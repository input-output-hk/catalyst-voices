import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class JoinedProposalBriefData extends Equatable {
  final ProposalOrDocument proposal;
  final ProposalSubmissionAction? actionType;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const JoinedProposalBriefData({
    required this.proposal,
    this.actionType,
    this.versionIds = const [],
    this.commentsCount = 0,
    this.isFavorite = false,
    this.originalAuthors = const [],
  });

  bool get isFinal => actionType == ProposalSubmissionAction.aFinal;

  int get iteration => versionIds.indexOf(proposal.version) + 1;

  @override
  List<Object?> get props => [
    proposal,
    actionType,
    versionIds,
    commentsCount,
    isFavorite,
    originalAuthors,
  ];
}
