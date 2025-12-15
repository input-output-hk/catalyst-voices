import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/model/signed_document_or_local_draft.dart';
import 'package:equatable/equatable.dart';

class RawProposalEntity extends Equatable {
  final SignedDocumentOrLocalDraft proposal;
  final SignedDocumentOrLocalDraft? template;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const RawProposalEntity({
    required this.proposal,
    required this.template,
    required this.versionIds,
    required this.commentsCount,
    required this.isFavorite,
    required this.originalAuthors,
  });

  @override
  List<Object?> get props => [
    proposal,
    template,
    versionIds,
    commentsCount,
    isFavorite,
    originalAuthors,
  ];

  RawProposal toModel() {
    return RawProposal(
      proposal: proposal.toModel(),
      template: template?.toModel(),
      versionIds: versionIds,
      commentsCount: commentsCount,
      isFavorite: isFavorite,
      originalAuthors: originalAuthors,
    );
  }
}
