import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:equatable/equatable.dart';

class JoinedProposalBriefEntity extends Equatable {
  final DocumentEntityV2 proposal;
  final DocumentEntityV2? template;
  final ProposalSubmissionAction? actionType;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const JoinedProposalBriefEntity({
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
}
