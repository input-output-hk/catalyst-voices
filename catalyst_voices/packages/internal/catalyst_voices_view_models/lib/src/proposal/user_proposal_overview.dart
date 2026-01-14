import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class UsersProposalOverview extends Equatable {
  final DocumentRef id;
  final CatalystId? author;
  final DocumentParameters parameters;
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
  final List<Collaborator> collaborators;
  final UserProposalOwnership ownership;

  const UsersProposalOverview({
    required this.id,
    this.author,
    required this.parameters,
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
    this.collaborators = const [],
    required this.ownership,
  });

  factory UsersProposalOverview.fromProposalBriefData({
    required ProposalBriefData proposalData,
    required bool fromActiveCampaign,
    CatalystId? activeAccountId,
  }) {
    final publish = ProposalPublish.getStatus(
      isFinal: proposalData.isFinal,
      ref: proposalData.id,
    );

    final versions = proposalData.versions!.toViewModels(
      finalVer: proposalData.isFinal ? proposalData.id.ver : null,
    );

    return UsersProposalOverview(
      id: proposalData.id,
      author: proposalData.author,
      parameters: proposalData.parameters,
      title: proposalData.title ?? '',
      updateDate: proposalData.createdAt,
      fundsRequested: proposalData.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      publish: publish,
      iteration: proposalData.iteration,
      versions: versions,
      commentsCount: proposalData.commentsCount ?? 0,
      category: proposalData.categoryName ?? '',
      fundNumber: proposalData.fundNumber,
      fromActiveCampaign: fromActiveCampaign,
      collaborators: proposalData.collaborators?.map(Collaborator.fromBriefData).toList() ?? [],
      ownership: UserProposalOwnership.fromActiveAccount(
        authorId: proposalData.author,
        activeAccountId: activeAccountId,
      ),
    );
  }

  /// Returns a list of all contributors associated with the proposal,
  /// including the main author (if specified) and all other collaborators.
  ///
  /// The **main proposer** (determined by the `author` field) is placed at the
  /// beginning of the list, followed by the explicit list of `collaborators`.
  ///
  /// If the `collaborators` list is empty, an empty list is returned, even if
  /// an `author` is present.
  List<Collaborator> get contributors {
    final mainProposer = author != null
        ? Collaborator(id: author!, status: ProposalsCollaborationStatus.mainProposer)
        : null;

    if (collaborators.isEmpty) return [];

    return [
      ?mainProposer,
      ...collaborators,
    ];
  }

  bool get hasNewerLocalIteration {
    if (versions.isEmpty) return false;
    return versions.any((version) => version.isLatestLocal) && !publish.isLocal;
  }

  @override
  List<Object?> get props => [
    id,
    author,
    parameters,
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
    Optional<CatalystId>? author,
    DocumentParameters? parameters,
    String? title,
    DateTime? updateDate,
    Money? fundsRequested,
    ProposalPublish? publish,
    int? iteration,
    List<ProposalVersionViewModel>? versions,
    int? commentsCount,
    String? category,
    int? fundNumber,
    bool? fromActiveCampaign,
    List<Collaborator>? collaborators,
    UserProposalOwnership? ownership,
  }) {
    return UsersProposalOverview(
      id: id ?? this.id,
      author: author.dataOr(this.author),
      parameters: parameters ?? this.parameters,
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
      collaborators: collaborators ?? this.collaborators,
      ownership: ownership ?? this.ownership,
    );
  }
}
