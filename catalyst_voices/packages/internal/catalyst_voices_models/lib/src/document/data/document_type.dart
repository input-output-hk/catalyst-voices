import 'package:catalyst_voices_models/src/document/data/document_content_type.dart';

// TODO(damian-molinski): update this list base on specs.
/// https://github.com/input-output-hk/catalyst-libs/blob/main/docs/src/architecture/08_concepts/signed_doc/types.md#document-base-types
enum DocumentBaseType {
  action,
  brand,
  proposal,
  campaign,
  category,
  comment,
  template,
  unknown;

  const DocumentBaseType();
}

/// List of types and metadata fields is here
/// https://input-output-hk.github.io/catalyst-libs/branch/feat_signed_object/architecture/08_concepts/signed_doc/types/
enum DocumentType {
  proposalDocument(
    uuid: '7808d2ba-d511-40af-84e8-c0d1625fdfdc',
    contentType: DocumentContentType.json,
  ),
  proposalTemplate(
    uuid: '0ce8ab38-9258-4fbc-a62e-7faa6e58318f',
    baseTypes: [DocumentBaseType.template],
    contentType: DocumentContentType.schemaJson,
  ),
  commentDocument(
    uuid: 'b679ded3-0e7c-41ba-89f8-da62a17898ea',
    contentType: DocumentContentType.json,
  ),
  commentTemplate(
    uuid: '0b8424d4-ebfd-46e3-9577-1775a69d290c',
    baseTypes: [DocumentBaseType.template],
    contentType: DocumentContentType.schemaJson,
  ),
  categoryParametersDocument(
    uuid: '48c20109-362a-4d32-9bba-e0a9cf8b45be',
    contentType: DocumentContentType.json,
  ),
  categoryParametersTemplate(
    uuid: '65b1e8b0-51f1-46a5-9970-72cdf26884be',
    baseTypes: [DocumentBaseType.template],
    contentType: DocumentContentType.schemaJson,
  ),
  campaignParametersDocument(
    uuid: '0110ea96-a555-47ce-8408-36efe6ed6f7c',
    contentType: DocumentContentType.json,
  ),
  campaignParametersTemplate(
    uuid: '7e8f5fa2-44ce-49c8-bfd5-02af42c179a3',
    baseTypes: [DocumentBaseType.template],
    contentType: DocumentContentType.schemaJson,
  ),
  brandParametersDocument(
    uuid: '3e4808cc-c86e-467b-9702-d60baa9d1fca',
    contentType: DocumentContentType.json,
  ),
  brandParametersTemplate(
    uuid: 'fd3c1735-80b1-4eea-8d63-5f436d97ea31',
    baseTypes: [DocumentBaseType.template],
    contentType: DocumentContentType.schemaJson,
  ),
  proposalActionDocument(
    uuid: '5e60e623-ad02-4a1b-a1ac-406db978ee48',
    baseTypes: [DocumentBaseType.action],
    contentType: DocumentContentType.json,
  ),
  unknown(
    uuid: '',
    contentType: DocumentContentType.unknown,
  );

  final String uuid;
  final List<DocumentBaseType> baseTypes;

  /// The [DocumentContentType] of the associated document payload.
  final DocumentContentType contentType;

  const DocumentType({
    required this.uuid,
    this.baseTypes = const [],
    required this.contentType,
  });

  static DocumentType fromJson(String data) {
    return DocumentType.values.firstWhere(
      (element) => element.uuid == data,
      orElse: () => DocumentType.unknown,
    );
  }

  static String toJson(DocumentType type) => type.uuid;
}
