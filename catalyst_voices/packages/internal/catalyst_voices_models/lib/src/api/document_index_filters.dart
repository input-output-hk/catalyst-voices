import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentIndexFilters extends Equatable {
  final List<DocumentType>? type;
  final List<String> categoriesIds;

  const DocumentIndexFilters({
    this.type,
    required this.categoriesIds,
  });

  DocumentIndexFilters.forCampaign(
    this.type, {
    required Campaign campaign,
  }) : categoriesIds = campaign.categories.map((e) => e.id.id).toSet().toList();

  @override
  List<Object?> get props => [
    type,
    categoriesIds,
  ];
}
