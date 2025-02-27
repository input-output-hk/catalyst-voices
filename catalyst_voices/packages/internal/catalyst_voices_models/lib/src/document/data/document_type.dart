/// List of types and metadata fields is here
/// https://input-output-hk.github.io/catalyst-libs/branch/feat_signed_object/architecture/08_concepts/signed_doc/types/
enum DocumentType {
  proposalDocument(uuid: '7808d2ba-d511-40af-84e8-c0d1625fdfdc'),
  proposalTemplate(uuid: '0ce8ab38-9258-4fbc-a62e-7faa6e58318f'),
  proposalComment(uuid: '0b8424d4-ebfd-46e3-9577-1775a69d290c'),
  unknown(uuid: '');

  final String uuid;

  const DocumentType({
    required this.uuid,
  });

  static DocumentType fromJson(String data) {
    return DocumentType.values.firstWhere(
      (element) => element.uuid == data,
      orElse: () => DocumentType.unknown,
    );
  }

  static String toJson(DocumentType type) => type.uuid;
}
