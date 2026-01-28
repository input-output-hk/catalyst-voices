import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/campaign/constant/f14_static_campaign_categories.dart';
import 'package:catalyst_voices_models/src/campaign/constant/f14_static_campaign_timeline.dart';
import 'package:catalyst_voices_models/src/campaign/constant/f15_static_campaign_categories.dart';
import 'package:catalyst_voices_models/src/campaign/constant/f15_static_campaign_timeline.dart';
import 'package:catalyst_voices_models/src/campaign/constant/fx_static_campaign_categories.dart';
import 'package:catalyst_voices_models/src/campaign/constant/fx_static_campaign_timeline.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class Campaign extends Equatable {
  // Frontend only references. F14 and F15 do not mean anything for backend.
  // They're only used to difference between campaigns.
  static const f14Ref = SignedDocumentRef.first('01997695-e26f-70db-b9d4-92574a806bcd');
  static const f15Ref = SignedDocumentRef.first('0199802c-21b4-7d91-986d-0e913cd81391');
  static const fXRef = SignedDocumentRef.first('019b4b08-6b39-7ec1-8ae5-6696f28e370c');

  static final all = <Campaign>[
    Campaign.f14(),
    Campaign.f15(),
    Campaign.fX(),
  ];

  // Using DocumentRef instead of SignedDocumentRef because in Campaign Treasury user can create
  // 'draft' version of campaign like Proposal
  final DocumentRef id;
  final String name;
  final String description;
  final MultiCurrencyAmount allFunds;
  final int fundNumber;
  final CampaignTimeline timeline;
  final List<CampaignCategory> categories;
  final CampaignPublish publish;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.allFunds,
    required this.fundNumber,
    required this.timeline,
    required this.categories,
    required this.publish,
  });

  factory Campaign.f14() {
    return Campaign(
      id: f14Ref,
      name: 'Catalyst Fund14',
      description: '''
Project Catalyst turns economic power into innovation power by using the Cardano Treasury to incentivize and fund community-approved ideas.''',
      allFunds: MultiCurrencyAmount.single(Currencies.ada.amount(20000000)),
      fundNumber: 14,
      timeline: f14StaticCampaignTimeline,
      publish: CampaignPublish.published,
      categories: f14StaticCampaignCategories,
    );
  }

  factory Campaign.f15() {
    return Campaign(
      id: f15Ref,
      name: 'Catalyst Fund15',
      description: '''TODO''',
      allFunds: MultiCurrencyAmount.list([
        Currencies.ada.amount(20000000),
        Currencies.usdm.amount(250000),
      ]),
      fundNumber: 15,
      timeline: f15StaticCampaignTimeline,
      publish: CampaignPublish.published,
      categories: f15StaticCampaignCategories,
    );
  }

  factory Campaign.fX() {
    return Campaign(
      id: fXRef,
      name: 'Catalyst Next Fund',
      description: '''TODO''',
      allFunds: MultiCurrencyAmount.list([
        Currencies.ada.amount(20000000),
        Currencies.usdm.amount(250000),
      ]),
      fundNumber: 16,
      timeline: fXStaticCampaignTimeline,
      publish: CampaignPublish.published,
      categories: fXStaticCampaignCategories,
    );
  }

  CampaignPhase? get closestPhaseState {
    final today = DateTimeExt.now();
    CampaignPhase? closestPhase;
    Duration? minDistance;

    for (final phase in timeline.phases) {
      Duration? distance;

      // Calculate distance to the closest date point (from or to) of the phase
      final from = phase.timeline.from;
      final to = phase.timeline.to;
      if (from != null && to != null) {
        final distanceFromStart = from.difference(today).abs();
        final distanceFromEnd = to.difference(today).abs();
        distance = distanceFromStart < distanceFromEnd ? distanceFromStart : distanceFromEnd;
      } else if (from != null) {
        distance = from.difference(today).abs();
      } else if (to != null) {
        distance = to.difference(today).abs();
      }

      if (distance != null && (minDistance == null || distance < minDistance)) {
        minDistance = distance;
        closestPhase = phase;
      }
    }
    return closestPhase;
  }

  bool get isVotingStateActive {
    return phaseStateTo(CampaignPhaseType.communityVoting).status.isActive;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    allFunds,
    fundNumber,
    timeline,
    publish,
    categories,
  ];

  DateTime? get startDate {
    final dates = timeline.phases.map((e) => e.timeline.from).nonNulls.toList()..sort();
    return dates.firstOrNull;
  }

  // We can have more than one state if the campaign timeline supports concurrent phases. For example
  // proposal submission can be concurrent with voting registration.
  CampaignState get state {
    final states = <CampaignPhaseState>[];

    for (final phase in timeline.phases) {
      final status = CampaignPhaseStatus.fromRange(phase.timeline, DateTimeExt.now());
      if (status.isActive) {
        states.add(CampaignPhaseState(phase: phase, status: status));
      }
    }

    if (states.isNotEmpty) return CampaignState(activePhases: states);

    final closestPhase = closestPhaseState;

    if (closestPhase case final phase?) {
      return CampaignState(
        activePhases: [
          CampaignPhaseState(
            phase: phase,
            status: CampaignPhaseStatus.fromRange(phase.timeline, DateTimeExt.now()),
          ),
        ],
      );
    }
    return const CampaignState(activePhases: []);
  }

  Campaign copyWith({
    DocumentRef? id,
    String? name,
    String? description,
    MultiCurrencyAmount? allFunds,
    int? fundNumber,
    CampaignTimeline? timeline,
    CampaignPublish? publish,
    List<CampaignCategory>? categories,
  }) {
    return Campaign(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      allFunds: allFunds ?? this.allFunds,
      fundNumber: fundNumber ?? this.fundNumber,
      timeline: timeline ?? this.timeline,
      publish: publish ?? this.publish,
      categories: categories ?? this.categories,
    );
  }

  bool hasAnyParameterId(DocumentParameters parameters) {
    return categories.any((category) => parameters.containsId(category.id.id));
  }

  bool hasCategory(String id) {
    return categories.any((element) => element.id.id == id);
  }

  /// Returns the state of the campaign for a specific phase at given [date], which defaults to
  /// [DateTimeExt.now].
  /// It's a shortcut for [state] when you are only interested in a specific phase. And want to know
  /// the status of that phase.
  CampaignPhaseState phaseStateTo(CampaignPhaseType type, [DateTime? date]) {
    date ??= DateTimeExt.now();

    final phase = timeline.phases.firstWhere(
      (phase) => phase.type == type,
      orElse: () => throw StateError('Type $type not found'),
    );
    return CampaignPhaseState(
      phase: phase,
      status: CampaignPhaseStatus.fromRange(phase.timeline, date),
    );
  }
}

final class CampaignPhaseState extends Equatable {
  final CampaignPhase phase;
  final CampaignPhaseStatus status;

  const CampaignPhaseState({
    required this.phase,
    required this.status,
  });

  @override
  List<Object?> get props => [phase, status];
}

enum CampaignPhaseStatus {
  upcoming,
  active,
  post;

  const CampaignPhaseStatus();

  factory CampaignPhaseStatus.fromRange(DateRange range, DateTime now) {
    final rangeStatus = range.rangeStatus(now);

    return switch (rangeStatus) {
      DateRangeStatus.before => CampaignPhaseStatus.upcoming,
      DateRangeStatus.inRange => CampaignPhaseStatus.active,
      DateRangeStatus.after => CampaignPhaseStatus.post,
    };
  }

  bool get isActive => this == CampaignPhaseStatus.active;

  bool get isPost => this == CampaignPhaseStatus.post;
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
  final List<CampaignPhaseState> activePhases;

  const CampaignState({
    required this.activePhases,
  });

  @override
  List<Object?> get props => [activePhases];
}
