import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_ref_dto.g.dart';

@JsonSerializable()
final class DocumentRefDto {
  final String id;
  final String? version;

  const DocumentRefDto({
    required this.id,
    this.version,
  });

  DocumentRefDto.fromModel(DocumentRef data)
      : this(
          id: data.id,
          version: data.version,
        );

  factory DocumentRefDto.fromJson(Map<String, dynamic> json) {
    return _$DocumentRefDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DocumentRefDtoToJson(this);

  DocumentRef toModel() {
    return DocumentRef(
      id: id,
      version: version,
    );
  }
}

@JsonSerializable()
final class SecuredDocumentRefDto {
  final DocumentRefDto ref;
  final String hash;

  const SecuredDocumentRefDto({
    required this.ref,
    required this.hash,
  });

  SecuredDocumentRefDto.fromModel(SecuredDocumentRef data)
      : this(
          ref: DocumentRefDto.fromModel(data.ref),
          hash: data.hash,
        );

  factory SecuredDocumentRefDto.fromJson(Map<String, dynamic> json) {
    return _$SecuredDocumentRefDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SecuredDocumentRefDtoToJson(this);

  SecuredDocumentRef toModel() {
    return SecuredDocumentRef(
      ref: ref.toModel(),
      hash: hash,
    );
  }
}
