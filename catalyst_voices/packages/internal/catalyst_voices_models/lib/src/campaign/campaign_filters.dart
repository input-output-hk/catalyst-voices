import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignFilters extends Equatable {
  final List<String> categoriesIds;

  const CampaignFilters({
    required this.categoriesIds,
  });

  factory CampaignFilters.active() {
    final categoriesIds = activeConstantDocumentRefs.map((e) => e.category.id).toList();
    return CampaignFilters(categoriesIds: categoriesIds);
  }

  @override
  List<Object?> get props => [categoriesIds];
}
