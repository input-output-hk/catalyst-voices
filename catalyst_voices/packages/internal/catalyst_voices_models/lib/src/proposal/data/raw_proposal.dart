import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class RawProposal extends Equatable {
  final DocumentData proposal;
  final DocumentData? template;
  final ProposalSubmissionAction? actionType;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const RawProposal({
    required this.proposal,
    required this.template,
    required this.actionType,
    required this.versionIds,
    required this.commentsCount,
    required this.isFavorite,
    required this.originalAuthors,
  });

  bool get isFinal => actionType == ProposalSubmissionAction.aFinal;

  int get iteration => versionIds.indexOf(proposal.id.ver!) + 1;

  @override
  List<Object?> get props => [
    proposal,
    template,
    actionType,
    versionIds,
    commentsCount,
    isFavorite,
    originalAuthors,
  ];
}
