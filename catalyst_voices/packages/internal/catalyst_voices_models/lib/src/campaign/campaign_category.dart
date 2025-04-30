import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final staticCampaignCategories = [
  CampaignCategory(
    selfRef: constantDocumentsRefs[0].category,
    proposalTemplateRef: constantDocumentsRefs[0].proposal,
    categoryName: 'Cardano Open:',
    categorySubname: 'Developers',
    description:
        '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[1].category,
    proposalTemplateRef: constantDocumentsRefs[1].proposal,
    categoryName: 'Cardano Open:',
    categorySubname: 'Ecosystem',
    description:
        '''Helps drive ecosystem growth and education to onboard more Cardano users though a broad range of marketing, education, Cardano governance, and regional community building initiatives''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[2].category,
    proposalTemplateRef: constantDocumentsRefs[2].proposal,
    categoryName: 'Cardano Use Cases:',
    categorySubname: 'Concept',
    description: '''
Accepts early stage ideas to deliver proof of concept, design research and basic prototyping through to MVP for innovative Cardano-based products, services, and business models.
''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[3].category,
    proposalTemplateRef: constantDocumentsRefs[3].proposal,
    categoryName: 'Cardano Use Cases:',
    categorySubname: 'Product',
    description:
        '''For established blockchain projects and teams looking to enhance existing applications and propositions by significantly extending current features and capabilities. The project must be for the benefit of the Cardano ecosystem and drive adoption and growth of transactions.''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[4].category,
    proposalTemplateRef: constantDocumentsRefs[4].proposal,
    categoryName: 'Cardano Partners:',
    categorySubname: 'Enterprise R&D',
    description: '''
Fuels the fly-wheels of innovation to ignite premium R&D projects that benefit Cardano led by or in partnership with exceptionally well-recognised leaders of industry.
''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[5].category,
    proposalTemplateRef: constantDocumentsRefs[5].proposal,
    categoryName: 'Cardano Partners:',
    categorySubname: 'Growth & Acceleration',
    description: '''
Fuels adoption by igniting premium advertising or venture building partnerships that benefit Cardano with Tier-1 marketing and accelerator leaders of industry.
''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[6].category,
    proposalTemplateRef: constantDocumentsRefs[6].proposal,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[7].category,
    proposalTemplateRef: constantDocumentsRefs[7].proposal,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[8].category,
    proposalTemplateRef: constantDocumentsRefs[8].proposal,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[9].category,
    proposalTemplateRef: constantDocumentsRefs[9].proposal,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[10].category,
    proposalTemplateRef: constantDocumentsRefs[10].proposal,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[11].category,
    proposalTemplateRef: constantDocumentsRefs[11].proposal,
    categoryName: '',
    categorySubname: '',
    description: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    requirements: const [],
    submissionCloseDate: DateTime.now(),
  ),
];

class CampaignCategory extends Equatable {
  final SignedDocumentRef selfRef;
  final SignedDocumentRef proposalTemplateRef;
  final String categoryName;
  final String categorySubname;
  final String description;
  final int proposalsCount;
  final Coin availableFunds;
  final Coin totalAsk;
  final ComparableRange<Coin> range;
  final List<CategoryDescription> descriptions;
  final String imageUrl;
  final List<String> requirements;
  final DateTime submissionCloseDate;

  const CampaignCategory({
    required this.selfRef,
    required this.proposalTemplateRef,
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

  String get categoryText => '$categoryName $categorySubname';

  @override
  List<Object?> get props => [
        selfRef,
        proposalTemplateRef,
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
    SignedDocumentRef? selfRef,
    SignedDocumentRef? proposalTemplateRef,
    String? categoryName,
    String? categorySubname,
    String? description,
    int? proposalsCount,
    Coin? availableFunds,
    String? imageUrl,
    Coin? totalAsk,
    ComparableRange<Coin>? range,
    List<CategoryDescription>? descriptions,
    List<String>? requirements,
    DateTime? submissionCloseDate,
  }) {
    return CampaignCategory(
      selfRef: selfRef ?? this.selfRef,
      proposalTemplateRef: proposalTemplateRef ?? this.proposalTemplateRef,
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
