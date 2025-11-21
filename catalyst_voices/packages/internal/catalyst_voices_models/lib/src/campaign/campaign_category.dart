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
  final MultiCurrencyAmount availableFunds;
  final Range<Money> range;
  final Currency currency;
  final List<CategoryDescription> descriptions;
  final String imageUrl;
  final List<String> dos;
  final List<String> donts;

  // TODO(damian-molinski): remove this
  final DateTime submissionCloseDate;

  const CampaignCategory({
    required this.selfRef,
    required this.proposalTemplateRef,
    required this.campaignRef,
    required this.categoryName,
    required this.categorySubname,
    required this.description,
    required this.shortDescription,
    required this.availableFunds,
    required this.imageUrl,
    required this.range,
    required this.currency,
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
    availableFunds,
    imageUrl,
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
    MultiCurrencyAmount? availableFunds,
    String? imageUrl,
    Range<Money>? range,
    Currency? currency,
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
      availableFunds: availableFunds ?? this.availableFunds,
      imageUrl: imageUrl ?? this.imageUrl,
      range: range ?? this.range,
      currency: currency ?? this.currency,
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
