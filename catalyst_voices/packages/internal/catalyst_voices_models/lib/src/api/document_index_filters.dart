import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentIndexFilters extends Equatable {
  final List<DocumentType>? type;
  final SignedDocumentRef? id;
  final List<String>? parameters;

  const DocumentIndexFilters({
    this.type,
    this.id,
    this.parameters,
  });

  DocumentIndexFilters.forCampaign({
    required Campaign campaign,
    DocumentType? type,
  }) : id = null,
       type = type != null ? [type] : null,
       parameters = campaign.categories.map((e) => e.id.id).toSet().toList();

  const DocumentIndexFilters.forTarget(SignedDocumentRef this.id) : type = null, parameters = null;

  @override
  List<Object?> get props => [
    type,
    id,
    parameters,
  ];

  DocumentIndexFilters copyWith({
    Optional<List<DocumentType>>? type,
    Optional<SignedDocumentRef>? id,
    Optional<List<String>>? parameters,
  }) {
    return DocumentIndexFilters(
      type: type.dataOr(this.type),
      id: id.dataOr(this.id),
      parameters: parameters.dataOr(this.parameters),
    );
  }
}
