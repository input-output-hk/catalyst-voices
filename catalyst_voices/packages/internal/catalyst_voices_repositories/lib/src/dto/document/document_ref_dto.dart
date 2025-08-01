import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:convert/convert.dart' show hex;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_ref_dto.g.dart';

@JsonSerializable()
final class DocumentRefDto {
  final String id;
  final String? version;
  @JsonKey(unknownEnumValue: DocumentRefDtoType.signed)
  final DocumentRefDtoType type;

  const DocumentRefDto({
    required this.id,
    this.version,
    required this.type,
  });

  factory DocumentRefDto.fromJson(Map<String, dynamic> json) {
    return _$DocumentRefDtoFromJson(json);
  }

  factory DocumentRefDto.fromModel(DocumentRef data) {
    final type = switch (data) {
      SignedDocumentRef() => DocumentRefDtoType.signed,
      DraftRef() => DocumentRefDtoType.draft,
    };

    return DocumentRefDto(
      id: data.id,
      version: data.version,
      type: type,
    );
  }

  Map<String, dynamic> toJson() => _$DocumentRefDtoToJson(this);

  DocumentRef toModel() {
    return switch (type) {
      DocumentRefDtoType.signed => SignedDocumentRef(id: id, version: version),
      DocumentRefDtoType.draft => DraftRef(id: id, version: version),
    };
  }
}

enum DocumentRefDtoType { signed, draft }

@JsonSerializable()
final class SecuredDocumentRefDto {
  final DocumentRefDto ref;
  final String hash;

  const SecuredDocumentRefDto({
    required this.ref,
    required this.hash,
  });

  factory SecuredDocumentRefDto.fromJson(Map<String, dynamic> json) {
    return _$SecuredDocumentRefDtoFromJson(json);
  }

  SecuredDocumentRefDto.fromModel(SecuredDocumentRef data)
      : this(
          ref: DocumentRefDto.fromModel(data.ref),
          hash: hex.encode(data.hash),
        );

  Map<String, dynamic> toJson() => _$SecuredDocumentRefDtoToJson(this);

  SecuredDocumentRef toModel() {
    return SecuredDocumentRef(
      ref: ref.toModel(),
      hash: Uint8List.fromList(hexDecode(hash)),
    );
  }
}
