import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show CampaignCategory, StaticCategoryDocumentData;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignCategoryViewModel extends Equatable {
  final String id;
  final String name;

  const CampaignCategoryViewModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

final class DetailedCampaignCategoryViewModel
    extends CampaignCategoryViewModel {
  final String subname;
  final String description;
  final int proposalsCount;
  final Coin availableFunds;
  final Coin totalAsk;
  final Range<int> range;
  final List<CategoryDescriptionViewModel> descriptions;
  final String imageUrl;
  final List<String> requirements;
  final DateTime submissionCloseDate;

  const DetailedCampaignCategoryViewModel({
    required this.subname,
    required this.description,
    required this.proposalsCount,
    required this.availableFunds,
    required this.imageUrl,
    required this.totalAsk,
    required this.range,
    required this.descriptions,
    required super.id,
    required super.name,
    this.requirements = const <String>[],
    required this.submissionCloseDate,
  });

  factory DetailedCampaignCategoryViewModel.dummy({String? id}) =>
      DetailedCampaignCategoryViewModel(
        id: id ?? '1',
        name: 'Cardano Open:',
        subname: 'Developers',
        description:
            '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
        proposalsCount: 263,
        availableFunds: const Coin(8000000),
        totalAsk: const Coin(400000),
        range: const Range(min: 15000, max: 100000),
        descriptions: List.filled(3, CategoryDescriptionViewModel.dummy()),
        imageUrl: CategoryImageUrl.imageUrl('1'),
        submissionCloseDate: DateTime.now(),
      );

  factory DetailedCampaignCategoryViewModel.fromModel(CampaignCategory model) {
    return DetailedCampaignCategoryViewModel(
      subname: model.categorySubname,
      description: model.description,
      proposalsCount: model.proposalsCount,
      availableFunds: model.availableFunds,
      imageUrl: CategoryImageUrl.imageUrl(model.uuid),
      totalAsk: model.totalAsk,
      range: model.range,
      descriptions: model.descriptions
          .map(CategoryDescriptionViewModel.fromModel)
          .toList(),
      requirements: model.requirements,
      submissionCloseDate: model.submissionCloseDate,
      id: model.uuid,
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
        imageUrl,
      ];
}

extension CategoryImageUrl on StaticCategoryDocumentData {
  static String imageUrl(String uuid) {
    return VoicesAssets.images.category.values
        .firstWhere(
          (img) => img.keyName.contains(uuid),
          orElse: () => VoicesAssets
              .images.category.category0194d4921daa75b5B4a45cf331cd8d1a,
        )
        .path;
  }
}
