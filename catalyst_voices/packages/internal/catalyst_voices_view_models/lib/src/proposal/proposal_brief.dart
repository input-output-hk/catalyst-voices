import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

final class ProposalBrief extends Equatable {
  final DocumentRef id;
  final String title;
  final String categoryName;
  final CatalystId? author;
  final Money fundsRequested;
  final int duration;
  final ProposalPublish publish;
  final String description;
  final int versionNumber;
  final DateTime updateDate;
  final int? commentsCount;
  final bool isFavorite;
  final VoteButtonData? voteData;
  final List<ProposalDataCollaborator>? collaborators;
  final bool votingEnabled;

  const ProposalBrief({
    required this.id,
    required this.title,
    required this.categoryName,
    this.author,
    required this.fundsRequested,
    required this.duration,
    required this.publish,
    required this.description,
    required this.versionNumber,
    required this.updateDate,
    this.commentsCount,
    this.isFavorite = false,
    this.voteData,
    this.collaborators,
    this.votingEnabled = false,
  });

  factory ProposalBrief.fromData(
    ProposalBriefData data, {
    bool showVoteData = false,
    bool votingEnabled = false,
  }) {
    return ProposalBrief(
      id: data.id,
      title: data.title ?? '',
      categoryName: data.categoryName ?? '',
      author: data.author,
      fundsRequested: data.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      duration: data.durationInMonths ?? 0,
      publish: data.isFinal ? ProposalPublish.submittedProposal : ProposalPublish.publishedDraft,
      description: data.description ?? '',
      versionNumber: data.iteration,
      updateDate: data.createdAt,
      commentsCount: data.commentsCount,
      isFavorite: data.isFavorite,
      voteData: showVoteData ? data.votes.toViewModel() : null,
      collaborators: data.collaborators,
      votingEnabled: votingEnabled,
    );
  }

  factory ProposalBrief.prototype() {
    return ProposalBrief(
      id: SignedDocumentRef.generateFirstRef(),
      title: 'Proposal Title',
      categoryName: 'Category Name',
      author: CatalystId(
        host: CatalystIdHost.cardano.host,
        role0Key: Uint8List.fromList(List.filled(32, 0)),
        username: 'Author Name',
      ),
      fundsRequested: Money.zero(currency: Currencies.ada),
      duration: 0,
      publish: ProposalPublish.publishedDraft,
      description: 'Proposal description',
      versionNumber: 1,
      updateDate: DateTime.now(),
      commentsCount: 0,
    );
  }

  List<CatalystId>? get acceptedCollaboratorsIds => collaborators
      ?.where((collaborator) => collaborator.status.isAccepted)
      .map((collaborator) => collaborator.id)
      .toList();

  String get formattedFunds {
    return MoneyFormatter.formatCompactRounded(fundsRequested);
  }

  @override
  List<Object?> get props => [
    id,
    title,
    categoryName,
    author,
    fundsRequested,
    duration,
    publish,
    description,
    versionNumber,
    updateDate,
    commentsCount,
    isFavorite,
    voteData,
    collaborators,
    votingEnabled,
  ];

  ProposalBrief copyWith({
    DocumentRef? id,
    String? title,
    String? categoryName,
    Optional<CatalystId>? author,
    Money? fundsRequested,
    int? duration,
    ProposalPublish? publish,
    String? description,
    int? versionNumber,
    DateTime? updateDate,
    Optional<int>? commentsCount,
    bool? isFavorite,
    Optional<VoteButtonData>? voteData,
    Optional<List<ProposalDataCollaborator>>? collaborators,
    bool? votingEnabled,
  }) {
    return ProposalBrief(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryName: categoryName ?? this.categoryName,
      author: author.dataOr(this.author),
      fundsRequested: fundsRequested ?? this.fundsRequested,
      duration: duration ?? this.duration,
      publish: publish ?? this.publish,
      description: description ?? this.description,
      versionNumber: versionNumber ?? this.versionNumber,
      updateDate: updateDate ?? this.updateDate,
      commentsCount: commentsCount.dataOr(this.commentsCount),
      isFavorite: isFavorite ?? this.isFavorite,
      voteData: voteData.dataOr(this.voteData),
      collaborators: collaborators.dataOr(this.collaborators),
      votingEnabled: votingEnabled ?? this.votingEnabled,
    );
  }
}

extension on ProposalBriefDataVotes? {
  VoteButtonData? toViewModel() {
    final instance = this;
    if (instance == null) {
      return null;
    }
    return VoteButtonData.fromVotes(
      currentDraft: instance.draft,
      lastCasted: instance.casted,
    );
  }
}
