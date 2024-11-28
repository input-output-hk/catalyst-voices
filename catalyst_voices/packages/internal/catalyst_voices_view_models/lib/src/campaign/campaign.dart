import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class Campaign extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int proposalsCount;
  final List<CampaignSection> sections;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.proposalsCount,
    required this.sections,
  });

  int get categoriesCount => sections.map((e) => e.category).toSet().length;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        startDate,
        endDate,
        proposalsCount,
        sections,
      ];
}
