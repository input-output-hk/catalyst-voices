import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show CampaignCategory, Currencies, Money, MultiCurrencyAmount, SignedDocumentRef;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart' hide Uuid;
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

/// View model for campaign category details.
///
/// This view model is used to display the details of a campaign category.
///
/// Data for this view model is extracted from the [CampaignCategory] model.
final class CampaignCategoryDetailsViewModel extends CampaignCategoryViewModel {
  final String subname;
  final String description;
  final String shortDescription;
  final int finalProposalsCount;
  final MultiCurrencyAmount availableFunds;
  final MultiCurrencyAmount totalAsk;
  final Range<Money> range;
  final List<CategoryDescriptionViewModel> descriptions;
  final SvgGenImage image;
  final List<String> dos;
  final List<String> donts;
  final DateTime submissionCloseDate;

  const CampaignCategoryDetailsViewModel({
    required super.id,
    required super.name,
    required this.subname,
    required this.description,
    required this.shortDescription,
    required this.finalProposalsCount,
    required this.availableFunds,
    required this.image,
    required this.totalAsk,
    required this.range,
    required this.descriptions,
    this.dos = const <String>[],
    this.donts = const <String>[],
    required this.submissionCloseDate,
  });

  factory CampaignCategoryDetailsViewModel.fromModel(
    CampaignCategory model, {
    required int finalProposalsCount,
    required MultiCurrencyAmount totalAsk,
  }) {
    return CampaignCategoryDetailsViewModel(
      id: model.id,
      name: model.categoryName,
      subname: model.categorySubname,
      description: model.description,
      shortDescription: model.shortDescription,
      finalProposalsCount: finalProposalsCount,
      availableFunds: model.availableFunds,
      image: CategoryImageUrl.image(model.id.id),
      totalAsk: totalAsk,
      range: model.range,
      descriptions: model.descriptions.map(CategoryDescriptionViewModel.fromModel).toList(),
      dos: model.dos,
      donts: model.donts,
      submissionCloseDate: model.submissionCloseDate,
    );
  }

  /// Creates a placeholder instance for use with Skeletonizer.
  ///
  /// This factory should only be used when skeleton loading states are needed,
  /// such as when wrapping widgets with Skeletonizer during data loading.
  factory CampaignCategoryDetailsViewModel.placeholder({String? id}) {
    return CampaignCategoryDetailsViewModel(
      id: SignedDocumentRef(id: id ?? const Uuid().v7()),
      name: 'Cardano Open:',
      subname: 'Developers',
      description:
          '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
      shortDescription: '',
      finalProposalsCount: 263,
      availableFunds: MultiCurrencyAmount.single(
        Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(8000000),
        ),
      ),
      totalAsk: MultiCurrencyAmount.single(
        Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(400000),
        ),
      ),
      range: Range(
        min: Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(15000),
        ),
        max: Money.fromMajorUnits(
          currency: Currencies.ada,
          majorUnits: BigInt.from(100000),
        ),
      ),
      descriptions: List.filled(3, CategoryDescriptionViewModel.dummy()),
      image: CategoryImageUrl.image('1'),
      submissionCloseDate: DateTimeExt.now(),
    );
  }

  String get availableFundsText {
    return MoneyFormatter.formatMultiCurrencyAmount(
      availableFunds,
      formatter: MoneyFormatter.formatDecimal,
    );
  }

  String get formattedName {
    return '$name $subname';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    subname,
    description,
    finalProposalsCount,
    availableFunds,
    totalAsk,
    range,
    descriptions,
    image,
    dos,
    donts,
    submissionCloseDate,
  ];
}

final class CampaignCategoryViewModel extends Equatable {
  final SignedDocumentRef id;
  final String name;

  const CampaignCategoryViewModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

final class CategoryImageUrl {
  CategoryImageUrl._();

  static SvgGenImage image(String uuid) {
    return VoicesAssets.images.category.values.firstWhere(
      (img) => img.path.contains(uuid),
      orElse: () {
        return VoicesAssets.images.category.category0194d49030bf70438c5cF0e09f8a6d8c;
      },
    );
  }
}
