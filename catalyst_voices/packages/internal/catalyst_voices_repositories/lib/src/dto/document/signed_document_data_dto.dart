import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signed_document_data_dto.g.dart';

@JsonSerializable()
final class SignedDocumentRefDto {
  final String id;
  final String? version;

  SignedDocumentRefDto({
    required this.id,
    this.version,
  });

  SignedDocumentRefDto.fromModel(SignedDocumentRef data)
      : this(
          id: data.id,
          version: data.version,
        );

  factory SignedDocumentRefDto.fromJson(Map<String, dynamic> json) {
    return _$SignedDocumentRefDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SignedDocumentRefDtoToJson(this);

  SignedDocumentRef toModel() {
    return SignedDocumentRef(
      id: id,
      version: version,
    );
  }
}

@JsonSerializable()
final class SecuredSignedDocumentRefDto {
  final SignedDocumentRefDto ref;
  final String hash;

  SecuredSignedDocumentRefDto({
    required this.ref,
    required this.hash,
  });

  SecuredSignedDocumentRefDto.fromModel(SecuredSignedDocumentRef data)
      : this(
          ref: SignedDocumentRefDto.fromModel(data.ref),
          hash: data.hash,
        );

  factory SecuredSignedDocumentRefDto.fromJson(Map<String, dynamic> json) {
    return _$SecuredSignedDocumentRefDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SecuredSignedDocumentRefDtoToJson(this);

  SecuredSignedDocumentRef toModel() {
    return SecuredSignedDocumentRef(
      ref: ref.toModel(),
      hash: hash,
    );
  }
}

@JsonSerializable()
final class SignedDocumentMetadataDto {
  @JsonKey(
    toJson: SignedDocumentType.toJson,
    fromJson: SignedDocumentType.fromJson,
  )
  final SignedDocumentType type;
  final String id;
  final String version;
  final SignedDocumentRefDto? ref;
  final SecuredSignedDocumentRefDto? refHash;
  final SignedDocumentRefDto? template;
  final String? brandId;
  final String? campaignId;
  final String? electionId;
  final String? categoryId;

  SignedDocumentMetadataDto({
    required this.type,
    required this.id,
    required this.version,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  });

  SignedDocumentMetadataDto.fromModel(SignedDocumentMetadata data)
      : this(
          type: data.type,
          id: data.id,
          version: data.version,
          ref: data.ref?.toDto(),
          refHash: data.refHash?.toDto(),
          template: data.template?.toDto(),
          brandId: data.brandId,
          campaignId: data.campaignId,
          electionId: data.electionId,
          categoryId: data.categoryId,
        );

  factory SignedDocumentMetadataDto.fromJson(Map<String, dynamic> json) {
    return _$SignedDocumentMetadataDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SignedDocumentMetadataDtoToJson(this);

  SignedDocumentMetadata toModel() {
    return SignedDocumentMetadata(
      type: type,
      id: id,
      version: version,
      ref: ref?.toModel(),
      refHash: refHash?.toModel(),
      template: template?.toModel(),
      brandId: brandId,
      campaignId: campaignId,
      electionId: electionId,
      categoryId: categoryId,
    );
  }
}

extension _SignedDocumentRefExt on SignedDocumentRef {
  SignedDocumentRefDto toDto() => SignedDocumentRefDto.fromModel(this);
}

extension _SecuredSignedDocumentRefExt on SecuredSignedDocumentRef {
  SecuredSignedDocumentRefDto toDto() {
    return SecuredSignedDocumentRefDto.fromModel(this);
  }
}
