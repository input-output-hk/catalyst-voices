import 'package:catalyst_voices_models/catalyst_voices_models.dart';

class SignedDocumentDataDto {
  final SignedDocumentMetadataDto metadata;
  final SignedDocumentDataPayload payload;

  SignedDocumentDataDto({
    required this.metadata,
    required this.payload,
  });

  SignedDocumentDataDto.fromModel(SignedDocumentData model)
      : this(
          metadata: SignedDocumentMetadataDto.fromModel(model.metadata),
          payload: model.payload,
        );

  SignedDocumentData toModel() {
    return SignedDocumentData(
      metadata: metadata.toModel(),
      payload: payload,
    );
  }
}

class SignedDocumentMetadataDto {
  final SignedDocumentType type;
  final String id;
  final String ver;
  final SignedDocumentRef? ref;
  final SecuredSignedDocumentRef? refHash;
  final SignedDocumentRef? template;
  final String? brandId;
  final String? campaignId;
  final String? electionId;
  final String? categoryId;

  SignedDocumentMetadataDto({
    required this.type,
    required this.id,
    required this.ver,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  });

  SignedDocumentMetadataDto.fromModel(SignedDocumentMetadata model)
      : this(
          type: model.type,
          id: model.id,
          ver: model.version,
          ref: model.ref,
          refHash: model.refHash,
          template: model.template,
          brandId: model.brandId,
          campaignId: model.campaignId,
          electionId: model.electionId,
          categoryId: model.campaignId,
        );

  SignedDocumentMetadata toModel() {
    return SignedDocumentMetadata(
      type: type,
      id: id,
      version: ver,
      ref: ref,
      refHash: refHash,
      template: template,
      brandId: brandId,
      campaignId: campaignId,
      electionId: electionId,
      categoryId: campaignId,
    );
  }
}
