import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show CampaignCategory, Currencies, Money, MultiCurrencyAmount, SignedDocumentRef;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// View model for campaign category details.
///
/// This view model is used to display the details of a campaign category.
///
/// Data for this view model is extracted from the [CampaignCategory] model.
final class CampaignCategoryDetailsViewModel extends CampaignCategoryViewModel {
  final String subname;
  final String description;
  final String shortDescription;
  final int proposalsCount;
  final MultiCurrencyAmount availableFunds;
  final MultiCurrencyAmount totalAsk;
  final Range<Money> range;
  final List<CategoryDescriptionViewModel> descriptions;
  final SvgGenImage image;
  final List<String> dos;
  final List<String> donts;
  final DateTime submissionCloseDate;

  const CampaignCategoryDetailsViewModel({
    required super.ref,
    required super.name,
    required this.subname,
    required this.description,
    required this.shortDescription,
    required this.proposalsCount,
    required this.availableFunds,
    required this.image,
    required this.totalAsk,
    required this.range,
    required this.descriptions,
    this.dos = const <String>[],
    this.donts = const <String>[],
    required this.submissionCloseDate,
  });

  factory CampaignCategoryDetailsViewModel.dummy({String? id}) => CampaignCategoryDetailsViewModel(
    ref: SignedDocumentRef(id: id ?? '1)'),
    name: 'Cardano Open:',
    subname: 'Developers',
    description:
        '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
    shortDescription: '',
    proposalsCount: 263,
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

  factory CampaignCategoryDetailsViewModel.fromModel(CampaignCategory model) {
    return CampaignCategoryDetailsViewModel(
      ref: model.selfRef,
      name: model.categoryName,
      subname: model.categorySubname,
      description: model.description,
      shortDescription: model.shortDescription,
      proposalsCount: model.proposalsCount,
      availableFunds: model.availableFunds,
      image: CategoryImageUrl.image(model.selfRef.id),
      totalAsk: model.totalAsk,
      range: model.range,
      descriptions: model.descriptions.map(CategoryDescriptionViewModel.fromModel).toList(),
      dos: model.dos,
      donts: model.donts,
      submissionCloseDate: model.submissionCloseDate,
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
    proposalsCount,
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
  final SignedDocumentRef ref;
  final String name;

  const CampaignCategoryViewModel({
    required this.ref,
    required this.name,
  });

  @override
  List<Object?> get props => [ref, name];
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
