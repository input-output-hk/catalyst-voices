import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/campaign/campaign_phase.dart';
import 'package:equatable/equatable.dart';

class Campaign extends Equatable {
  static final f14Ref = SignedDocumentRef.generateFirstRef();
  // Using DocumentRef instead of SignedDocumentRef because in Campaign Treasury user can create
  // 'draft' version of campaign like Proposal
  final DocumentRef selfRef;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final int fundNumber;
  final CampaignTimeline timeline;
  final CampaignPublish publish;

  const Campaign({
    required this.selfRef,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.fundNumber,
    required this.timeline,
    required this.publish,
  });

  CampaignState get state {
    final now = DateTime.now();
    final phase = timeline.phases.
  }

  @override
  List<Object?> get props => [
        selfRef,
        name,
        description,
        startDate,
        endDate,
        proposalsCount,
        fundNumber,
        timeline,
        publish,
      ];

  Campaign copyWith({
    DocumentRef? selfRef,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? proposalsCount,
    int? fundNumber,
    CampaignTimeline? timeline,
    CampaignPublish? publish,
  }) {
    return Campaign(
      selfRef: selfRef ?? this.selfRef,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      fundNumber: fundNumber ?? this.fundNumber,
      timeline: timeline ?? this.timeline,
      publish: publish ?? this.publish,
    );
  }
}

enum CampaignPhaseStatus {
  upcoming,
  active,
  post;
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
