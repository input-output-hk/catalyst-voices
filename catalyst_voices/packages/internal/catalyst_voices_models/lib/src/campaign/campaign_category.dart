import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Representation of single [Campaign] category.
///
/// Should have factory constructor from document representation.
class CampaignCategory extends Equatable {
  final SignedDocumentRef selfRef;
  final SignedDocumentRef proposalTemplateRef;
  final SignedDocumentRef campaignRef;
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
    required this.campaignRef,
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

  String get formattedCategoryName => '$categoryName $categorySubname';

  @override
  List<Object?> get props => [
    selfRef,
    proposalTemplateRef,
    campaignRef,
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
    SignedDocumentRef? campaignRef,
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
      campaignRef: campaignRef ?? this.campaignRef,
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
