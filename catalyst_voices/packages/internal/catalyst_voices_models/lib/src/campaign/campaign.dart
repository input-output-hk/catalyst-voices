import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class Campaign extends CampaignBase {
  final DocumentSchema proposalTemplate;

  const Campaign({
    required super.id,
    required super.name,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.proposalsCount,
    required super.publish,
    required super.proposalTemplateId,
    required this.proposalTemplate,
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
    String? proposalTemplateId,
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
      proposalTemplateId: proposalTemplateId ?? this.proposalTemplateId,
      proposalTemplate: proposalTemplate ?? this.proposalTemplate,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        proposalTemplate,
      ];
}
