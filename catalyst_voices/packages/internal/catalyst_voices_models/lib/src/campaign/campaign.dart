import 'package:catalyst_voices_models/src/campaign/campaign_publish.dart';
import 'package:catalyst_voices_models/src/campaign/campaign_section.dart';
import 'package:catalyst_voices_models/src/proposal/proposal_template.dart';
import 'package:equatable/equatable.dart';

final class Campaign extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final List<CampaignSection> sections;
  final CampaignPublish publish;
  final ProposalTemplate proposalTemplate;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.sections,
    required this.publish,
    required this.proposalTemplate,
  });

  int get categoriesCount => sections.map((e) => e.category).toSet().length;

  Campaign copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? proposalsCount,
    List<CampaignSection>? sections,
    CampaignPublish? publish,
    ProposalTemplate? proposalTemplate,
  }) {
    return Campaign(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      sections: sections ?? this.sections,
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
        sections,
        publish,
        proposalTemplate,
      ];
}
