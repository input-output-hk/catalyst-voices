import 'package:equatable/equatable.dart';

class StaticCategoryDocumentData extends Equatable {
  static const documents = [
    StaticCategoryDocumentData('0194d490-30bf-7473-81c8-a0eaef369619'),
    StaticCategoryDocumentData('0194d490-30bf-7043-8c5c-f0e09f8a6d8c'),
    StaticCategoryDocumentData('0194d490-30bf-7e75-95c1-a6cf0e8086d9'),
    StaticCategoryDocumentData('0194d490-30bf-7703-a1c0-83a916b001e7'),
    StaticCategoryDocumentData('0194d490-30bf-79d1-9a0f-84943123ef38'),
    StaticCategoryDocumentData('0194d490-30bf-706d-91c6-0d4707f74cdf'),
    StaticCategoryDocumentData('0194d490-30bf-759e-b729-304306fbaa5e'),
    StaticCategoryDocumentData('0194d490-30bf-7e27-b5fd-de3133b54bf6'),
    StaticCategoryDocumentData('0194d490-30bf-7f9e-8a5d-91fb67c078f2'),
    StaticCategoryDocumentData('0194d490-30bf-7676-9658-36c0b67e656e'),
    StaticCategoryDocumentData('0194d490-30bf-7978-b031-7aa2ccc5e3fd'),
    StaticCategoryDocumentData('0194d490-30bf-7d34-bba9-8498094bd627'),
  ];

  final String uuid;

  const StaticCategoryDocumentData(this.uuid);

  @override
  List<Object?> get props => [uuid];
}

class StaticCommentTemplateData extends Equatable {
  static final documents = [
    StaticCommentTemplateData(
      '0194d494-4402-7e0e-b8d6-171f8fea18b0',
      StaticCategoryDocumentData.documents[0].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7444-9058-9030815eb029',
      StaticCategoryDocumentData.documents[1].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7351-b4f7-24938dc2c12e',
      StaticCategoryDocumentData.documents[2].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-79ad-93ba-4d7a0b65d563',
      StaticCategoryDocumentData.documents[3].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7cee-a5a6-5739839b3b8a',
      StaticCategoryDocumentData.documents[4].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7aee-8b24-b5300c976846',
      StaticCategoryDocumentData.documents[5].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7d75-be7f-1c4f3471a53c',
      StaticCategoryDocumentData.documents[6].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7a2c-8971-1b4c255c826d',
      StaticCategoryDocumentData.documents[7].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7074-86ac-3efd097ba9b0',
      StaticCategoryDocumentData.documents[8].uuid,
    ),
    StaticCommentTemplateData(
      '0194d494-4402-7202-8ebb-8c4c47c286d8',
      StaticCategoryDocumentData.documents[9].uuid,
    ),
  ];
  final String uuid;

  final String categoryUuid;

  const StaticCommentTemplateData(this.uuid, this.categoryUuid);

  @override
  List<Object?> get props => [uuid, categoryUuid];
}

class StaticProposalTemplateData extends Equatable {
  static final documents = [
    StaticProposalTemplateData(
      '0194d492-1daa-75b5-b4a4-5cf331cd8d1a',
      StaticCategoryDocumentData.documents[0].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-7371-8bd3-c15811b2b063',
      StaticCategoryDocumentData.documents[1].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-79c7-a222-2c3b581443a8',
      StaticCategoryDocumentData.documents[2].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-716f-a04e-f422f08a99dc',
      StaticCategoryDocumentData.documents[3].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-78fc-818a-bf20fc3e9b87',
      StaticCategoryDocumentData.documents[4].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-7d98-a3aa-c57d99121f78',
      StaticCategoryDocumentData.documents[5].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-77be-a1a5-c238fe25fe4f',
      StaticCategoryDocumentData.documents[6].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-7254-a512-30a4cdecfb90',
      StaticCategoryDocumentData.documents[7].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-7de9-b535-1a0b0474ed4e',
      StaticCategoryDocumentData.documents[8].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-7fce-84ee-b872a4661075',
      StaticCategoryDocumentData.documents[9].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-7878-9bcc-2c79fef0fc13',
      StaticCategoryDocumentData.documents[10].uuid,
    ),
    StaticProposalTemplateData(
      '0194d492-1daa-722f-94f4-687f2c068a5d',
      StaticCategoryDocumentData.documents[11].uuid,
    ),
  ];

  final String uuid;

  final String categoryUuid;

  const StaticProposalTemplateData(
    this.uuid,
    this.categoryUuid,
  );

  @override
  List<Object?> get props => [uuid, categoryUuid];
}
