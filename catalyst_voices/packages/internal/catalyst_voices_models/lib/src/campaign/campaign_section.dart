import 'package:catalyst_voices_models/src/campaign/campaign_category.dart';
import 'package:equatable/equatable.dart';

final class CampaignSection extends Equatable {
  final String id;
  final CampaignCategory category;
  final String title;
  final String body;

  const CampaignSection({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        body,
      ];
}
