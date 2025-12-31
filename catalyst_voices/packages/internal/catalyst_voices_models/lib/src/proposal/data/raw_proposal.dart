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
    this.actionType,
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

  RawProposal copyWith({
    DocumentData? proposal,
    Optional<DocumentData>? template,
    Optional<ProposalSubmissionAction>? actionType,
    List<String>? versionIds,
    int? commentsCount,
    bool? isFavorite,
    List<CatalystId>? originalAuthors,
  }) {
    return RawProposal(
      proposal: proposal ?? this.proposal,
      template: template.dataOr(this.template),
      actionType: actionType.dataOr(this.actionType),
      versionIds: versionIds ?? this.versionIds,
      commentsCount: commentsCount ?? this.commentsCount,
      isFavorite: isFavorite ?? this.isFavorite,
      originalAuthors: originalAuthors ?? this.originalAuthors,
    );
  }
}
