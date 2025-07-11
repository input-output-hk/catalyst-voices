import 'package:equatable/equatable.dart';

/// Representation of campaign.
///
/// Should have factory constructor from document representation.
final class Campaign extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final CampaignPublish publish;
  final int categoriesCount;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.publish,
    required this.categoriesCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        startDate,
        endDate,
        proposalsCount,
        publish,
      ];

  Campaign copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? proposalsCount,
    CampaignPublish? publish,
    int? categoriesCount,
  }) {
    return Campaign(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      publish: publish ?? this.publish,
      categoriesCount: categoriesCount ?? this.categoriesCount,
    );
  }
}

enum CampaignPublish {
  draft,
  published;

  bool get isDraft => this == draft;
}
