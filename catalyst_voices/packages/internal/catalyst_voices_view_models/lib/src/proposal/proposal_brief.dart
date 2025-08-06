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
  final VoteButtonData? vote;

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
    this.vote,
  });

  factory ProposalBrief.fromProposal(
    Proposal proposal, {
    bool isFavorite = false,
    Vote? draftVote,
  }) {
    return ProposalBrief(
      selfRef: proposal.selfRef,
      title: proposal.title,
      categoryName: proposal.category,
      author: proposal.author,
      fundsRequested: proposal.fundsRequested,
      duration: proposal.duration,
      publish: proposal.publish,
      description: proposal.description,
      versionNumber: proposal.versionCount,
      updateDate: proposal.updateDate,
      commentsCount: proposal.commentsCount,
      isFavorite: isFavorite,
      vote: VoteButtonData.fromVotes(
        currentDraft: draftVote,
        lastCasted: proposal.lastCastedVote,
      ),
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
        vote,
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
    Optional<VoteButtonData>? vote,
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
      vote: vote.dataOr(this.vote),
    );
  }
}
