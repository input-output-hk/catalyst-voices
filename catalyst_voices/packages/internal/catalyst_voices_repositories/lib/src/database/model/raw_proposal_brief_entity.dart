import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/model/signed_document_or_local_draft.dart';
import 'package:equatable/equatable.dart';

class RawProposalBriefEntity extends Equatable {
  final SignedDocumentOrLocalDraft proposal;
  final SignedDocumentOrLocalDraft? template;
  final ProposalSubmissionAction? actionType;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const RawProposalBriefEntity({
    required this.proposal,
    required this.template,
    required this.actionType,
    required this.versionIds,
    required this.commentsCount,
    required this.isFavorite,
    required this.originalAuthors,
  });

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

  RawProposalBrief toModel() {
    return RawProposalBrief(
      proposal: proposal.toModel(),
      template: template?.toModel(),
      actionType: actionType,
      versionIds: versionIds,
      commentsCount: commentsCount,
      isFavorite: isFavorite,
      originalAuthors: originalAuthors,
    );
  }
}
