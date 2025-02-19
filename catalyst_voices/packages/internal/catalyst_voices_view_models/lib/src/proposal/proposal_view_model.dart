import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:equatable/equatable.dart';

/// A proposal view model spanning proposals in different stages.
sealed class ProposalViewModel extends Equatable {
  final String id;
  final bool isFavorite;

  const ProposalViewModel({
    required this.id,
    required this.isFavorite,
  });

  factory ProposalViewModel.fromProposalAtStage({
    required Proposal proposal,
    required String campaignName,
    required CampaignStage campaignStage,
  }) {
    switch (campaignStage) {
      case CampaignStage.draft:
      case CampaignStage.scheduled:
      case CampaignStage.live:
        return PendingProposal.fromProposal(
          proposal,
          campaignName: campaignName,
        );
      case CampaignStage.completed:
        // TODO(dtscalac): whether proposal is funded or not should depend
        // not on campaign stage but on the proposal properties.
        // In the future when proposals are refined update this.
        return FundedProposal.fromProposal(
          proposal,
          campaignName: campaignName,
        );
    }
  }

  ProposalViewModel copyWith({
    String? id,
    bool? isFavorite,
  });

  @override
  List<Object?> get props => [id, isFavorite];
}

/// Defines the pending proposal that is not funded yet.
final class PendingProposal extends ProposalViewModel {
  final String campaignName;
  final String category;
  final String title;
  final DateTime lastUpdateDate;
  final Coin _fundsRequested;
  final int commentsCount;
  final String description;
  final ProposalPublish publishStage;
  final int version;
  final int duration;
  final String author;

  const PendingProposal({
    required super.id,
    super.isFavorite = false,
    required this.campaignName,
    required this.category,
    required this.title,
    required this.lastUpdateDate,
    required Coin fundsRequested,
    required this.commentsCount,
    required this.description,
    required this.publishStage,
    required this.version,
    required this.duration,
    required this.author,
  }) : _fundsRequested = fundsRequested;

  PendingProposal.fromProposal(
    Proposal proposal, {
    required String campaignName,
  }) : this(
          id: proposal.id,
          campaignName: campaignName,
          category: proposal.category,
          title: proposal.title,
          lastUpdateDate: proposal.updateDate,
          fundsRequested: proposal.fundsRequested,
          commentsCount: proposal.commentsCount,
          description: proposal.description,
          publishStage: proposal.publish,
          version: proposal.version,
          duration: proposal.duration,
          author: proposal.author,
        );

  String get fundsRequested {
    return CryptocurrencyFormatter.decimalFormat(_fundsRequested);
  }

  @override
  PendingProposal copyWith({
    String? id,
    bool? isFavorite,
    String? campaignName,
    String? category,
    String? title,
    DateTime? lastUpdateDate,
    Coin? fundsRequested,
    int? commentsCount,
    String? description,
    ProposalPublish? publishStage,
    int? version,
    int? duration,
    String? author,
  }) {
    return PendingProposal(
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      campaignName: campaignName ?? this.campaignName,
      category: category ?? this.category,
      title: title ?? this.title,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      fundsRequested: fundsRequested ?? _fundsRequested,
      commentsCount: commentsCount ?? this.commentsCount,
      description: description ?? this.description,
      publishStage: publishStage ?? this.publishStage,
      version: version ?? this.version,
      duration: duration ?? this.duration,
      author: author ?? this.author,
    );
  }

  factory PendingProposal.dummy() {
    return PendingProposal(
      id: 'f14/2',
      campaignName: 'F14',
      category: 'Cardano Use Cases: Concept',
      title: 'Proposal Title that rocks the world',
      lastUpdateDate: DateTime.now().minusDays(2),
      fundsRequested: const Coin(55000),
      commentsCount: 0,
      description: """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
          .replaceAll('\n', ' '),
      publishStage: ProposalPublish.published,
      version: 1,
      duration: 6,
      author: 'Alex Wells',
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        campaignName,
        category,
        title,
        lastUpdateDate,
        _fundsRequested.value,
        commentsCount,
        description,
        publishStage,
        version,
        duration,
        author,
      ];
}

/// Defines the already funded proposal.
final class FundedProposal extends ProposalViewModel {
  final String campaignName;
  final String category;
  final String title;
  final DateTime fundedDate;
  final Coin _fundsRequested;
  final int commentsCount;
  final String description;

  const FundedProposal({
    required super.id,
    super.isFavorite = false,
    required this.campaignName,
    required this.category,
    required this.title,
    required this.fundedDate,
    required Coin fundsRequested,
    required this.commentsCount,
    required this.description,
  }) : _fundsRequested = fundsRequested;

  FundedProposal.fromProposal(
    Proposal proposal, {
    required String campaignName,
  }) : this(
          id: proposal.id,
          campaignName: campaignName,
          category: proposal.category,
          title: proposal.title,
          fundedDate: proposal.fundedDate!,
          fundsRequested: proposal.fundsRequested,
          commentsCount: proposal.commentsCount,
          description: proposal.description,
        );

  String get fundsRequested {
    return CryptocurrencyFormatter.formatAmount(_fundsRequested);
  }

  @override
  FundedProposal copyWith({
    String? id,
    bool? isFavorite,
    String? campaignName,
    String? category,
    String? title,
    DateTime? fundedDate,
    Coin? fundsRequested,
    int? commentsCount,
    String? description,
  }) {
    return FundedProposal(
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      campaignName: campaignName ?? this.campaignName,
      category: category ?? this.category,
      title: title ?? this.title,
      fundedDate: fundedDate ?? this.fundedDate,
      fundsRequested: fundsRequested ?? _fundsRequested,
      commentsCount: commentsCount ?? this.commentsCount,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        campaignName,
        category,
        title,
        fundedDate,
        _fundsRequested,
        commentsCount,
        description,
      ];
}
