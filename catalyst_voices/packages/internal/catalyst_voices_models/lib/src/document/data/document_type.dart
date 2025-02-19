/// List of types and metadata fields is here
/// https://input-output-hk.github.io/catalyst-libs/branch/feat_signed_object/architecture/08_concepts/signed_doc/types/
enum DocumentType {
  proposalDocument(uuid: '7808d2ba-d511-40af-84e8-c0d1625fdfdc'),
  proposalTemplate(uuid: '0ce8ab38-9258-4fbc-a62e-7faa6e58318f'),
  commentDocument(uuid: 'b679ded3-0e7c-41ba-89f8-da62a17898ea'),
  commentTemplate(uuid: '0b8424d4-ebfd-46e3-9577-1775a69d290c'),
  reviewDocument(uuid: 'e4caf5f0-098b-45fd-94f3-0702a4573db5'),
  reviewTemplate(uuid: 'ebe5d0bf-5d86-4577-af4d-008fddbe2edc'),
  categoryParametersDocument(uuid: '48c20109-362a-4d32-9bba-e0a9cf8b45be'),
  categoryParametersTemplate(uuid: '65b1e8b0-51f1-46a5-9970-72cdf26884be'),
  campaignParametersDocument(uuid: '0110ea96-a555-47ce-8408-36efe6ed6f7c'),
  campaignParametersTemplate(uuid: '7e8f5fa2-44ce-49c8-bfd5-02af42c179a3'),
  brandParametersDocument(uuid: '3e4808cc-c86e-467b-9702-d60baa9d1fca'),
  brandParametersTemplate(uuid: 'fd3c1735-80b1-4eea-8d63-5f436d97ea31'),
  proposalActionDocument(uuid: '5e60e623-ad02-4a1b-a1ac-406db978ee48'),
  unknown(uuid: '');

  final String uuid;

  static String toJson(DocumentType type) => type.uuid;

  static DocumentType fromJson(String data) {
    return DocumentType.values.firstWhere(
      (element) => element.uuid == data,
      orElse: () => DocumentType.unknown,
    );
  }

  const DocumentType({
    required this.uuid,
  });
}
