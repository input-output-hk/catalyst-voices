import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show CampaignCategory, SignedDocumentRef;
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
  final Coin availableFunds;
  final Coin totalAsk;
  final ComparableRange<Coin> range;
  final List<CategoryDescriptionViewModel> descriptions;
  final SvgGenImage image;
  final List<String> dos;
  final List<String> donts;
  final DateTime submissionCloseDate;

  const CampaignCategoryDetailsViewModel({
    required this.subname,
    required this.description,
    required this.shortDescription,
    required this.proposalsCount,
    required this.availableFunds,
    required this.image,
    required this.totalAsk,
    required this.range,
    required this.descriptions,
    required super.id,
    required super.name,
    this.dos = const <String>[],
    this.donts = const <String>[],
    required this.submissionCloseDate,
  });

  factory CampaignCategoryDetailsViewModel.dummy({String? id}) => CampaignCategoryDetailsViewModel(
        id: SignedDocumentRef(id: id ?? '1)'),
        name: 'Cardano Open:',
        subname: 'Developers',
        description:
            '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
        shortDescription: '',
        proposalsCount: 263,
        availableFunds: const Coin(8000000),
        totalAsk: const Coin(400000),
        range: const ComparableRange(
          min: Coin.fromWholeAda(15000),
          max: Coin.fromWholeAda(100000),
        ),
        descriptions: List.filled(3, CategoryDescriptionViewModel.dummy()),
        image: CategoryImageUrl.image('1'),
        submissionCloseDate: DateTime.now(),
      );

  factory CampaignCategoryDetailsViewModel.fromModel(CampaignCategory model) {
    return CampaignCategoryDetailsViewModel(
      id: model.selfRef,
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
      name: model.categoryName,
    );
  }

  String get availableFundsText {
    return CryptocurrencyFormatter.decimalFormat(availableFunds);
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
        image,
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
