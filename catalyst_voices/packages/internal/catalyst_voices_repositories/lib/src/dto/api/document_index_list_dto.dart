import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_index_list_dto.g.dart';

// Note. OpenAPI spec is incorrect at the moment. This dto is here as
// temporary workaround.
@JsonSerializable()
final class DocumentIndexListDto {
  final String id;
  final List<IndividualDocumentVersion> ver;

  DocumentIndexListDto({
    required this.id,
    required this.ver,
  });

  factory DocumentIndexListDto.fromJson(Map<String, dynamic> json) {
    return _$DocumentIndexListDtoFromJson(json);
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => _$DocumentIndexListDtoToJson(this);
}

@JsonSerializable()
final class DocumentRefForFilteredDocuments {
  final String id;
  final String? ver;

  DocumentRefForFilteredDocuments({
    required this.id,
    this.ver,
  });

  factory DocumentRefForFilteredDocuments.fromJson(Map<String, dynamic> json) {
    return _$DocumentRefForFilteredDocumentsFromJson(json);
  }

  @visibleForTesting
  Map<String, dynamic> toJson() {
    return _$DocumentRefForFilteredDocumentsToJson(this);
  }
}

@JsonSerializable()
final class IndividualDocumentVersion {
  final String ver;
  final String type;
  final DocumentRefForFilteredDocuments? ref;
  final DocumentRefForFilteredDocuments? reply;
  final DocumentRefForFilteredDocuments? template;
  final DocumentRefForFilteredDocuments? brand;
  final DocumentRefForFilteredDocuments? campaign;
  final DocumentRefForFilteredDocuments? category;

  IndividualDocumentVersion({
    required this.ver,
    required this.type,
    this.ref,
    this.reply,
    this.template,
    this.brand,
    this.campaign,
    this.category,
  });

  factory IndividualDocumentVersion.fromJson(Map<String, dynamic> json) {
    return _$IndividualDocumentVersionFromJson(json);
  }

  @visibleForTesting
  Map<String, dynamic> toJson() => _$IndividualDocumentVersionToJson(this);
}
