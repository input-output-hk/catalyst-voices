import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Enum representing the state of a campaign.
/// Draft: campaign is not published yet.
/// Published: campaign is published and can be seen by users.
enum CampaignPublish {
  draft,
  published;

  bool get isDraft => this == draft;
}

final class Campaign extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final CampaignPublish publish;
  final DocumentSchema proposalTemplate;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.publish,
    required this.proposalTemplate,
  });

  int get categoriesCount => 0;

  Campaign copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? proposalsCount,
    CampaignPublish? publish,
    DocumentSchema? proposalTemplate,
  }) {
    return Campaign(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      publish: publish ?? this.publish,
      proposalTemplate: proposalTemplate ?? this.proposalTemplate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        startDate,
        endDate,
        proposalsCount,
        publish,
        proposalTemplate,
      ];
}
