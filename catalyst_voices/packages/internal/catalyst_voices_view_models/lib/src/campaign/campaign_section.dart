import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignSection extends Equatable implements MenuItem {
  @override
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
  String get label => category.name;

  @override
  bool get isEnabled => true;

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        body,
      ];
}
