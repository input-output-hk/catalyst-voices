import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class UsersProposalOverview extends Equatable {
  final DocumentRef id;
  final String title;
  final DateTime updateDate;
  final Money fundsRequested;
  final ProposalPublish publish;
  final int iteration;
  final List<ProposalVersionViewModel> versions;
  final int commentsCount;
  final String category;
  final int fundNumber;
  final bool fromActiveCampaign;
  final List<Collaborator> _collaborators;
  final UserProposalOwnership ownership;

  const UsersProposalOverview({
    required this.id,
    required this.title,
    required this.updateDate,
    required this.fundsRequested,
    required this.publish,
    required this.iteration,
    required this.versions,
    required this.commentsCount,
    required this.category,
    required this.fundNumber,
    required this.fromActiveCampaign,
    List<Collaborator> collaborators = const [],
    required this.ownership,
  }) : _collaborators = collaborators;

  factory UsersProposalOverview.fromProposalBriefData({
    required ProposalBriefData proposalData,
    required bool fromActiveCampaign,
    CatalystId? activeAccountId,
  }) {
    final publish = _ProposalPublishExt.getStatus(
      isFinal: proposalData.isFinal,
      ref: proposalData.id,
    );

    return UsersProposalOverview(
      id: proposalData.id,
      title: proposalData.title,
      updateDate: proposalData.updateDate,
      fundsRequested: proposalData.fundsRequested,
      publish: publish,
      iteration: proposalData.iteration,
      // TODO(LynxLynxx): map versions when they will be implemented
      versions: const [],
      commentsCount: proposalData.commentsCount ?? 0,
      category: proposalData.categoryName,
      fundNumber: proposalData.fundNumber,
      fromActiveCampaign: fromActiveCampaign,
      collaborators: proposalData.collaborators?.map(Collaborator.fromBriefData).toList() ?? [],
      ownership: UserProposalOwnership.fromActiveAccount(
        authorId: proposalData.author,
        activeAccountId: activeAccountId,
      ),
    );
  }

  List<Collaborator> get collaborators => _collaborators;

  bool get hasNewerLocalIteration {
    if (versions.isEmpty) return false;
    return versions.any((version) => version.isLatestLocal) && !publish.isLocal;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    updateDate,
    fundsRequested,
    publish,
    versions,
    commentsCount,
    category,
    fundNumber,
    fromActiveCampaign,
    collaborators,
    iteration,
  ];

  UsersProposalOverview copyWith({
    DocumentRef? id,
    String? title,
    DateTime? updateDate,
    Money? fundsRequested,
    ProposalPublish? publish,
    int? iteration,
    List<ProposalVersionViewModel>? versions,
    int? commentsCount,
    String? category,
    SignedDocumentRef? categoryId,
    int? fundNumber,
    bool? fromActiveCampaign,
    List<Collaborator>? collaborators,
    UserProposalOwnership? ownership,
  }) {
    return UsersProposalOverview(
      id: id ?? this.id,
      title: title ?? this.title,
      updateDate: updateDate ?? this.updateDate,
      fundsRequested: fundsRequested ?? this.fundsRequested,
      publish: publish ?? this.publish,
      iteration: iteration ?? this.iteration,
      versions: versions ?? this.versions,
      commentsCount: commentsCount ?? this.commentsCount,
      category: category ?? this.category,
      fundNumber: fundNumber ?? this.fundNumber,
      fromActiveCampaign: fromActiveCampaign ?? this.fromActiveCampaign,
      collaborators: collaborators ?? _collaborators,
      ownership: ownership ?? this.ownership,
    );
  }
}

extension _ProposalPublishExt on ProposalPublish {
  static ProposalPublish getStatus({required bool isFinal, required DocumentRef ref}) {
    if (isFinal) {
      return ProposalPublish.submittedProposal;
    } else if (!isFinal && DocumentRef is SignedDocumentRef) {
      return ProposalPublish.publishedDraft;
    } else {
      return ProposalPublish.localDraft;
    }
  }
}
