import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/document/data/static_document_data.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final staticCampaignCategories = [
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[0].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[0].uuid,
    categoryName: 'Cardano Open:',
    categorySubname: 'Developers',
    description:
        '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[1].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[1].uuid,
    categoryName: 'Cardano Open:',
    categorySubname: 'Ecosystem',
    description:
        '''Helps drive ecosystem growth and education to onboard more Cardano users though a broad range of marketing, education, Cardano governance, and regional community building initiatives''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[2].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[2].uuid,
    categoryName: 'Cardano Use Cases:',
    categorySubname: 'Concept',
    description: '''
Accepts early stage ideas to deliver proof of concept, design research and basic prototyping through to MVP for innovative Cardano-based products, services, and business models.
''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[3].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[3].uuid,
    categoryName: 'Cardano Use Cases:',
    categorySubname: 'Product',
    description:
        '''For established blockchain projects and teams looking to enhance existing applications and propositions by significantly extending current features and capabilities. The project must be for the benefit of the Cardano ecosystem and drive adoption and growth of transactions.''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[4].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[4].uuid,
    categoryName: 'Cardano Partners:',
    categorySubname: 'Enterprise R&D',
    description: '''
Fuels the fly-wheels of innovation to ignite premium R&D projects that benefit Cardano led by or in partnership with exceptionally well-recognised leaders of industry.
''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[5].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[5].uuid,
    categoryName: 'Cardano Partners:',
    categorySubname: 'Growth & Acceleration',
    description: '''
Fuels adoption by igniting premium advertising or venture building partnerships that benefit Cardano with Tier-1 marketing and accelerator leaders of industry.
''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[6].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[6].uuid,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[7].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[7].uuid,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[8].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[8].uuid,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[9].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[9].uuid,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[10].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[10].uuid,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    uuid: StaticProposalTemplateData.documents[11].categoryUuid,
    proposalTemplateUuid: StaticProposalTemplateData.documents[11].uuid,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const Range(min: 0, max: 0),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
];

class CampaignCategory extends Equatable {
  final String uuid;
  final String proposalTemplateUuid;
  final String categoryName;
  final String categorySubname;
  final String description;
  final int proposalsCount;
  final Coin availableFunds;
  final Coin totalAsk;
  final Range<int> range;
  final List<CategoryDescription> descriptions;
  final String imageUrl;
  final List<String> requirements;
  final DateTime submissionCloseDate;

  const CampaignCategory({
    required this.uuid,
    required this.proposalTemplateUuid,
    required this.categoryName,
    required this.categorySubname,
    required this.description,
    required this.proposalsCount,
    required this.availableFunds,
    required this.imageUrl,
    required this.totalAsk,
    required this.range,
    required this.descriptions,
    required this.requirements,
    required this.submissionCloseDate,
  });

  @override
  List<Object?> get props => [
        uuid,
        proposalTemplateUuid,
        categoryName,
        categorySubname,
        description,
        proposalsCount,
        availableFunds,
        imageUrl,
        totalAsk,
        range,
        descriptions,
        requirements,
        submissionCloseDate,
      ];

  CampaignCategory copyWith({
    String? uuid,
    String? proposalTemplateUuid,
    String? categoryName,
    String? categorySubname,
    String? description,
    int? proposalsCount,
    Coin? availableFunds,
    String? imageUrl,
    Coin? totalAsk,
    Range<int>? range,
    List<CategoryDescription>? descriptions,
    List<String>? requirements,
    DateTime? submissionCloseDate,
  }) {
    return CampaignCategory(
      uuid: uuid ?? this.uuid,
      proposalTemplateUuid: proposalTemplateUuid ?? this.proposalTemplateUuid,
      categoryName: categoryName ?? this.categoryName,
      categorySubname: categorySubname ?? this.categorySubname,
      description: description ?? this.description,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      availableFunds: availableFunds ?? this.availableFunds,
      imageUrl: imageUrl ?? this.imageUrl,
      totalAsk: totalAsk ?? this.totalAsk,
      range: range ?? this.range,
      descriptions: descriptions ?? this.descriptions,
      requirements: requirements ?? this.requirements,
      submissionCloseDate: submissionCloseDate ?? this.submissionCloseDate,
    );
  }
}

class CategoryDescription extends Equatable {
  final String title;
  final String description;

  const CategoryDescription({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}
