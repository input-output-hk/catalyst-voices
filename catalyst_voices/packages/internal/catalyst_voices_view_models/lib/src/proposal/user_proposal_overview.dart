import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

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
  final List<CollaboratorInvite> invites;

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
    this.invites = const [],
  });

  factory UsersProposalOverview.fromProposalBriefData({
    required ProposalBriefData proposalData,
    required bool fromActiveCampaign,
  }) {
    final updateDate = UuidV7.parseDateTime(
      proposalData.id.ver ?? proposalData.id.id,
    );
    final publish = _ProposalPublishExt.getStatus(
      isFinal: proposalData.isFinal,
      ref: proposalData.id,
    );

    return UsersProposalOverview(
      id: proposalData.id,
      title: proposalData.title,
      updateDate: updateDate,
      fundsRequested: proposalData.fundsRequested,
      publish: publish,
      iteration: proposalData.iteration,
      versions: const [],
      commentsCount: proposalData.commentsCount ?? 0,
      category: proposalData.categoryName,
      fundNumber: proposalData.fundNumber,
      fromActiveCampaign: fromActiveCampaign,
      invites: proposalData.collaborators?.map(CollaboratorInvite.fromBriefData).toList() ?? [],
    );
  }

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
    invites,
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
    List<CollaboratorInvite>? invites,
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
      invites: invites ?? this.invites,
    );
  }
}

extension _ProposalPublishExt on ProposalPublish {
  static ProposalPublish getStatus({required bool isFinal, required DocumentRef ref}) {
    if (isFinal && DocumentRef is SignedDocumentRef) {
      return ProposalPublish.submittedProposal;
    } else if (!isFinal && DocumentRef is SignedDocumentRef) {
      return ProposalPublish.publishedDraft;
    } else {
      return ProposalPublish.localDraft;
    }
  }
}
