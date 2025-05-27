import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final staticCampaignCategories = [
  CampaignCategory(
    selfRef: constantDocumentsRefs[0].category,
    proposalTemplateRef: constantDocumentsRefs[0].proposal,
    categoryName: 'Cardano Use Case:',
    categorySubname: 'Partners & Products',
    description:
        '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
    shortDescription:
        '''For Tier-1 partnerships and real-world pilots that scale Cardano adoption through high-impact use. cases.''',
    proposalsCount: 0,
    availableFunds: const Coin.fromWholeAda(100000),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Use Cases: Concepts category fuels disruptive, untested Cardano-based use cases to experiment with novel utility and on-chain transactions. 

The funding category supports early-stage ideas - spanning proof of concept, design research, basic prototyping, and minimum viable products (MVPs) - to lay the foundation for innovative products, services, or business models. 

Unlike Cardano Use Cases: Partners & Products, which funds mature, deployed products or enterprise partnerships with proven adoption, this category is for newer Catalyst entrants or innovators validating novel concepts and product market fit with no prior development or funding.''',
      ),
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Use Cases: Concepts category fuels disruptive, untested Cardano-based use cases to experiment with novel utility and on-chain transactions. 

The funding category supports early-stage ideas - spanning proof of concept, design research, basic prototyping, and minimum viable products (MVPs) - to lay the foundation for innovative products, services, or business models. 

Unlike Cardano Use Cases: Partners & Products, which funds mature, deployed products or enterprise partnerships with proven adoption, this category is for newer Catalyst entrants or innovators validating novel concepts and product market fit with no prior development or funding.''',
      ),
    ],
    dos: const [
      '**Provide** proof of established partnerships',
      '**Provide** proof of established partnerships',
    ],
    donts: const [
      'No prototype R&D',
      'No prototype R&D',
    ],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[1].category,
    proposalTemplateRef: constantDocumentsRefs[1].proposal,
    categoryName: 'Cardano Use Case:',
    categorySubname: 'Concept',
    description:
        '''Helps drive ecosystem growth and education to onboard more Cardano users though a broad range of marketing, education, Cardano governance, and regional community building initiatives''',
    shortDescription: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    dos: const [],
    donts: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[2].category,
    proposalTemplateRef: constantDocumentsRefs[2].proposal,
    categoryName: 'Cardano Open:',
    categorySubname: 'Developers',
    description: '''
Accepts early stage ideas to deliver proof of concept, design research and basic prototyping through to MVP for innovative Cardano-based products, services, and business models.
''',
    shortDescription:
        ''' Cardano Use Cases: Concepts funds novel, early-stage Cardano-based concepts developing proof of concept prototypes through deploying minimum viable products (MVP) to validate innovative products, services, or business models driving Cardano adoption.''',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    dos: const [],
    donts: const [],
    submissionCloseDate: DateTime.now(),
  ),
  CampaignCategory(
    selfRef: constantDocumentsRefs[3].category,
    proposalTemplateRef: constantDocumentsRefs[3].proposal,
    categoryName: 'Cardano Open:',
    categorySubname: 'Ecosystem',
    description:
        '''For established blockchain projects and teams looking to enhance existing applications and propositions by significantly extending current features and capabilities. The project must be for the benefit of the Cardano ecosystem and drive adoption and growth of transactions.''',
    shortDescription: '',
    proposalsCount: 0,
    availableFunds: const Coin(0),
    imageUrl: '',
    totalAsk: const Coin(0),
    range: const ComparableRange(
      min: Coin.fromWholeAda(30000),
      max: Coin.fromWholeAda(100000),
    ),
    descriptions: const [],
    dos: const [],
    donts: const [],
    submissionCloseDate: DateTime.now(),
  ),
];

class CampaignCategory extends Equatable {
  final SignedDocumentRef selfRef;
  final SignedDocumentRef proposalTemplateRef;
  final String categoryName;
  final String categorySubname;
  final String description;
  final String shortDescription;
  final int proposalsCount;
  final Coin availableFunds;
  final Coin totalAsk;
  final ComparableRange<Coin> range;
  final List<CategoryDescription> descriptions;
  final String imageUrl;
  final List<String> dos;
  final List<String> donts;
  final DateTime submissionCloseDate;

  const CampaignCategory({
    required this.selfRef,
    required this.proposalTemplateRef,
    required this.categoryName,
    required this.categorySubname,
    required this.description,
    required this.shortDescription,
    required this.proposalsCount,
    required this.availableFunds,
    required this.imageUrl,
    required this.totalAsk,
    required this.range,
    required this.descriptions,
    required this.dos,
    required this.donts,
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
        shortDescription,
        proposalsCount,
        availableFunds,
        imageUrl,
        totalAsk,
        range,
        descriptions,
        dos,
        donts,
        submissionCloseDate,
      ];

  CampaignCategory copyWith({
    SignedDocumentRef? selfRef,
    SignedDocumentRef? proposalTemplateRef,
    String? categoryName,
    String? categorySubname,
    String? description,
    String? shortDescription,
    int? proposalsCount,
    Coin? availableFunds,
    String? imageUrl,
    Coin? totalAsk,
    ComparableRange<Coin>? range,
    List<CategoryDescription>? descriptions,
    List<String>? dos,
    List<String>? donts,
    DateTime? submissionCloseDate,
  }) {
    return CampaignCategory(
      selfRef: selfRef ?? this.selfRef,
      proposalTemplateRef: proposalTemplateRef ?? this.proposalTemplateRef,
      categoryName: categoryName ?? this.categoryName,
      categorySubname: categorySubname ?? this.categorySubname,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      availableFunds: availableFunds ?? this.availableFunds,
      imageUrl: imageUrl ?? this.imageUrl,
      totalAsk: totalAsk ?? this.totalAsk,
      range: range ?? this.range,
      descriptions: descriptions ?? this.descriptions,
      dos: dos ?? this.dos,
      donts: donts ?? this.donts,
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
