import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentIndexFilters extends Equatable {
  final DocumentType? type;
  final SignedDocumentRef? id;
  final List<String>? categoriesIds;

  const DocumentIndexFilters({
    this.type,
    this.id,
    this.categoriesIds,
  });

  DocumentIndexFilters.forCampaign({
    required Campaign campaign,
    this.type,
  }) : id = null,
       categoriesIds = campaign.categories.map((e) => e.id.id).toSet().toList();

  const DocumentIndexFilters.forTarget(SignedDocumentRef this.id)
    : type = null,
      categoriesIds = null;

  @override
  List<Object?> get props => [
    type,
    id,
    categoriesIds,
  ];

  DocumentIndexFilters copyWith({
    Optional<DocumentType>? type,
    Optional<SignedDocumentRef>? id,
    Optional<List<String>>? categoriesIds,
  }) {
    return DocumentIndexFilters(
      type: type.dataOr(this.type),
      id: id.dataOr(this.id),
      categoriesIds: categoriesIds.dataOr(this.categoriesIds),
    );
  }
}
