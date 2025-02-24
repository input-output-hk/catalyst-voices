import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Enum representing the state of a campaign.
/// Draft: campaign is not published yet.
/// Published: campaign is published and can be seen by users.
enum CampaignPublish {
  draft,
  published;

  bool get isDraft => this == draft;
}

// Note. Most, if not all, fields will be removed from here because they come
// from document.
base class CampaignBase extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final CampaignPublish publish;

  const CampaignBase({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.publish,
  });

  int get categoriesCount => 0;

  // TODO(damian-molinski): this should come from api
  DocumentRef get proposalTemplateRef {
    return const SignedDocumentRef(id: 'schema');
  }

  Campaign toCampaign() {
    return Campaign(
      id: id,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      proposalsCount: proposalsCount,
      publish: publish,
    );
  }

  CampaignBase copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? proposalsCount,
    CampaignPublish? publish,
  }) {
    return CampaignBase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      publish: publish ?? this.publish,
    );
  }

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        name,
        description,
        startDate,
        endDate,
        proposalsCount,
        publish,
      ];
}
