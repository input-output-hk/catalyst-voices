import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class Campaign extends CampaignBase {
  const Campaign({
    required super.id,
    required super.name,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.proposalsCount,
    required super.publish,
  });

  @override
  Campaign copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? proposalsCount,
    CampaignPublish? publish,
  }) {
    return Campaign(
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
  List<Object?> get props => [
        ...super.props,
      ];
}
