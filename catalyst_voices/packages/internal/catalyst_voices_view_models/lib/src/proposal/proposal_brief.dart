import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class ProposalBrief extends Equatable {
  final DocumentRef selfRef;
  final String title;
  final String categoryName;
  final String? author;
  final Coin fundsRequested;
  final int duration;
  final ProposalPublish publish;
  final String description;
  final int versionNumber;
  final DateTime updateDate;
  final int commentsCount;
  final bool isFavorite;

  const ProposalBrief({
    required this.selfRef,
    required this.title,
    required this.categoryName,
    this.author,
    required this.fundsRequested,
    required this.duration,
    required this.publish,
    required this.description,
    required this.versionNumber,
    required this.updateDate,
    required this.commentsCount,
    this.isFavorite = false,
  });

  factory ProposalBrief.fromProposal(
    Proposal proposal, {
    bool isFavorite = false,
    String categoryName = '',
  }) {
    return ProposalBrief(
      selfRef: proposal.selfRef,
      title: proposal.title,
      categoryName: categoryName,
      author: proposal.author,
      fundsRequested: proposal.fundsRequested,
      duration: proposal.duration,
      publish: proposal.publish,
      description: proposal.description,
      versionNumber: proposal.versionNumber,
      updateDate: proposal.updateDate,
      commentsCount: proposal.commentsCount,
      isFavorite: isFavorite,
    );
  }

  String get formattedFunds {
    return CryptocurrencyFormatter.formatAmount(fundsRequested);
  }

  @override
  List<Object?> get props => [
        selfRef,
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
      ];

  ProposalBrief copyWith({
    DocumentRef? selfRef,
    String? title,
    String? categoryName,
    Optional<String>? author,
    Coin? fundsRequested,
    int? duration,
    ProposalPublish? publish,
    String? description,
    int? versionNumber,
    DateTime? updateDate,
    int? commentsCount,
    bool? isFavorite,
  }) {
    return ProposalBrief(
      selfRef: selfRef ?? this.selfRef,
      title: title ?? this.title,
      categoryName: categoryName ?? this.categoryName,
      author: author.dataOr(this.author),
      fundsRequested: fundsRequested ?? this.fundsRequested,
      duration: duration ?? this.duration,
      publish: publish ?? this.publish,
      description: description ?? this.description,
      versionNumber: versionNumber ?? this.versionNumber,
      updateDate: updateDate ?? this.updateDate,
      commentsCount: commentsCount ?? this.commentsCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProposalBriefVoting extends ProposalBrief {
  final VoteButtonData voteData;

  const ProposalBriefVoting({
    required super.selfRef,
    required super.title,
    required super.categoryName,
    required super.fundsRequested,
    required super.duration,
    required super.publish,
    required super.description,
    required super.versionNumber,
    required super.updateDate,
    required super.commentsCount,
    super.isFavorite,
    super.author,
    required this.voteData,
  });

  factory ProposalBriefVoting.fromProposal(
    Proposal proposal, {
    bool isFavorite = false,
    String categoryName = '',
    Vote? draftVote,
    Vote? lastCastedVote,
  }) {
    return ProposalBriefVoting(
      selfRef: proposal.selfRef,
      title: proposal.title,
      categoryName: categoryName,
      author: proposal.author,
      fundsRequested: proposal.fundsRequested,
      duration: proposal.duration,
      publish: proposal.publish,
      description: proposal.description,
      versionNumber: proposal.versionNumber,
      updateDate: proposal.updateDate,
      commentsCount: proposal.commentsCount,
      isFavorite: isFavorite,
      voteData: VoteButtonData.fromVotes(
        currentDraft: draftVote,
        lastCasted: lastCastedVote,
      ),
    );
  }

  factory ProposalBriefVoting.fromProposalWithContext(
    ProposalWithContext data, {
    Vote? draftVote,
  }) {
    final proposal = data.proposal;
    final category = data.category;
    final userContext = data.user;

    return ProposalBriefVoting(
      selfRef: proposal.selfRef,
      title: proposal.title,
      categoryName: category.categoryText,
      author: proposal.author,
      fundsRequested: proposal.fundsRequested,
      duration: proposal.duration,
      publish: proposal.publish,
      description: proposal.description,
      versionNumber: proposal.versionNumber,
      updateDate: proposal.updateDate,
      commentsCount: proposal.commentsCount,
      isFavorite: userContext.isFavorite,
      voteData: VoteButtonData.fromVotes(
        currentDraft: draftVote,
        lastCasted: userContext.lastCastedVote,
      ),
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        voteData,
      ];

  @override
  ProposalBriefVoting copyWith({
    DocumentRef? selfRef,
    String? title,
    String? categoryName,
    Optional<String>? author,
    Coin? fundsRequested,
    int? duration,
    ProposalPublish? publish,
    String? description,
    int? versionNumber,
    DateTime? updateDate,
    int? commentsCount,
    bool? isFavorite,
    VoteButtonData? voteData,
  }) {
    return ProposalBriefVoting(
      selfRef: selfRef ?? this.selfRef,
      title: title ?? this.title,
      categoryName: categoryName ?? this.categoryName,
      author: author.dataOr(this.author),
      fundsRequested: fundsRequested ?? this.fundsRequested,
      duration: duration ?? this.duration,
      publish: publish ?? this.publish,
      description: description ?? this.description,
      versionNumber: versionNumber ?? this.versionNumber,
      updateDate: updateDate ?? this.updateDate,
      commentsCount: commentsCount ?? this.commentsCount,
      isFavorite: isFavorite ?? this.isFavorite,
      voteData: voteData ?? this.voteData,
    );
  }
}
