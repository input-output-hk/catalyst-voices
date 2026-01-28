import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class RawProposalBrief extends Equatable {
  final DocumentData proposal;
  final DocumentData? template;
  final ProposalSubmissionAction? actionType;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const RawProposalBrief({
    required this.proposal,
    required this.template,
    required this.actionType,
    required this.commentsCount,
    required this.isFavorite,
    required this.originalAuthors,
  });

  bool get isFinal => actionType == ProposalSubmissionAction.aFinal;

  @override
  List<Object?> get props => [
    proposal,
    template,
    actionType,
    commentsCount,
    isFavorite,
    originalAuthors,
  ];
}
