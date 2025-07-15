import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

class Campaign extends Equatable {
  // Using DocumentRef instead of SignedDocumentRef because in Campaign Treasury user can create
  // 'draft' version of campaign like Proposal
  final DocumentRef selfRef;
  final String name;
  final String description;
  final Coin allFunds;
  final int fundNumber;
  final CampaignTimeline timeline;
  final CampaignPublish publish;
  final List<CampaignCategory> categories;

  const Campaign({
    required this.selfRef,
    required this.name,
    required this.description,
    required this.allFunds,
    required this.fundNumber,
    required this.timeline,
    required this.publish,
    required this.categories,
  });

  @override
  List<Object?> get props => [
        selfRef,
        name,
        description,
        allFunds,
        fundNumber,
        timeline,
        publish,
        categories,
      ];

  CampaignState get state {
    final today = DateTime.now();
    CampaignPhase? closestPhase;
    Duration? minDistance;

    for (final phase in timeline.phases) {
      if (phase.timeline.from != null) {
        final distance = phase.timeline.from!.difference(today).abs();
        if (minDistance == null || distance < minDistance) {
          minDistance = distance;
          closestPhase = phase;
        }
      } else if (phase.timeline.to != null) {
        final distance = today.difference(phase.timeline.to!).abs();
        if (minDistance == null || distance < minDistance) {
          minDistance = distance;
          closestPhase = phase;
        }
      }
    }
    if (closestPhase == null) {
      throw Exception('No closest phase found');
    }

    return CampaignState(
      phase: closestPhase,
      status: CampaignPhaseStatus.fromRange(closestPhase.timeline),
    );
  }

  Campaign copyWith({
    DocumentRef? selfRef,
    String? name,
    String? description,
    Coin? allFunds,
    int? fundNumber,
    CampaignTimeline? timeline,
    CampaignPublish? publish,
    List<CampaignCategory>? categories,
  }) {
    return Campaign(
      selfRef: selfRef ?? this.selfRef,
      name: name ?? this.name,
      description: description ?? this.description,
      allFunds: allFunds ?? this.allFunds,
      fundNumber: fundNumber ?? this.fundNumber,
      timeline: timeline ?? this.timeline,
      publish: publish ?? this.publish,
      categories: categories ?? this.categories,
    );
  }

  CampaignState stateTo(CampaignPhaseStage stage) {
    final phase = timeline.phases.firstWhere((phase) => phase.stage == stage);
    return CampaignState(
      phase: phase,
      status: CampaignPhaseStatus.fromRange(phase.timeline),
    );
  }
}

final class CampaignDetail extends Campaign {
  final Coin totalAsk;

  const CampaignDetail({
    required super.selfRef,
    required super.name,
    required super.description,
    required super.allFunds,
    required super.fundNumber,
    required super.timeline,
    required super.publish,
    required super.categories,
    required this.totalAsk,
  });

  factory CampaignDetail.fromCampaign(Campaign campaign, Coin totalAsk) {
    return CampaignDetail(
      selfRef: campaign.selfRef,
      name: campaign.name,
      description: campaign.description,
      allFunds: campaign.allFunds,
      fundNumber: campaign.fundNumber,
      timeline: campaign.timeline,
      publish: campaign.publish,
      categories: campaign.categories,
      totalAsk: totalAsk,
    );
  }
}

enum CampaignPhaseStatus {
  upcoming,
  active,
  post;

  const CampaignPhaseStatus();

  factory CampaignPhaseStatus.fromRange(DateRange range) {
    final rangeStatus = range.rangeStatusNow();
    return switch (rangeStatus) {
      DateRangeStatus.before => CampaignPhaseStatus.upcoming,
      DateRangeStatus.inRange => CampaignPhaseStatus.active,
      DateRangeStatus.after => CampaignPhaseStatus.post,
    };
  }
}

enum CampaignPublish {
  draft,
  published;

  const CampaignPublish();

  factory CampaignPublish.fromDocumentRefType(DocumentRef documentRef) {
    return switch (documentRef) {
      DraftRef() => CampaignPublish.draft,
      SignedDocumentRef() => CampaignPublish.published,
    };
  }
}

final class CampaignState extends Equatable {
  final CampaignPhase phase;
  final CampaignPhaseStatus status;

  const CampaignState({
    required this.phase,
    required this.status,
  });

  @override
  List<Object?> get props => [phase, status];
}

extension F14Campaign on Campaign {
  static final f14Ref = SignedDocumentRef.generateFirstRef();
  static Campaign staticContent = Campaign(
    selfRef: f14Ref,
    name: 'Catalyst Fund14',
    description: '''
Project Catalyst turns economic power into innovation power by using the Cardano Treasury to incentivize and fund community-approved ideas.''',
    allFunds: const Coin.fromWholeAda(20000000),
    fundNumber: 14,
    timeline: CampaignTimeline(phases: CampaignPhaseX.f14StaticContent),
    publish: CampaignPublish.published,
    categories: staticCampaignCategories,
  );
}
