import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class ProposalBrief extends Equatable {
  final DocumentRef id;
  final String title;
  final String categoryName;
  final String? author;
  final Money fundsRequested;
  final int duration;
  final ProposalPublish publish;
  final String description;
  final int versionNumber;
  final DateTime updateDate;
  final int? commentsCount;
  final bool isFavorite;
  final VoteButtonData? voteData;

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
  });

  factory ProposalBrief.fromData(ProposalBriefData data) {
    return ProposalBrief(
      id: data.id,
      title: data.title,
      categoryName: data.categoryName,
      author: data.authorName,
      fundsRequested: data.fundsRequested,
      duration: data.durationInMonths,
      publish: data.isFinal ? ProposalPublish.submittedProposal : ProposalPublish.publishedDraft,
      description: data.description,
      versionNumber: data.iteration,
      updateDate: data.createdAt,
      commentsCount: data.commentsCount,
      isFavorite: data.isFavorite,
      voteData: data.votes.toViewModel(),
    );
  }

  factory ProposalBrief.prototype() {
    return ProposalBrief(
      id: SignedDocumentRef.generateFirstRef(),
      title: 'Proposal Title',
      categoryName: 'Category Name',
      author: 'Author Name',
      fundsRequested: Money.zero(currency: Currencies.ada),
      duration: 0,
      publish: ProposalPublish.publishedDraft,
      description: 'Proposal description',
      versionNumber: 1,
      updateDate: DateTime.now(),
      commentsCount: 0,
    );
  }

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
  ];

  ProposalBrief copyWith({
    DocumentRef? id,
    String? title,
    String? categoryName,
    Optional<String>? author,
    Money? fundsRequested,
    int? duration,
    ProposalPublish? publish,
    String? description,
    int? versionNumber,
    DateTime? updateDate,
    Optional<int>? commentsCount,
    bool? isFavorite,
    Optional<VoteButtonData>? voteData,
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
