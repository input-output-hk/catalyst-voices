import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignCategory extends Equatable {
  final String id;
  final String name;

  const CampaignCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

final class CampaignCategoryViewModel extends CampaignCategory {
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

  const CampaignCategoryViewModel({
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

  factory CampaignCategoryViewModel.dummy({String? id}) =>
      CampaignCategoryViewModel(
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
        imageUrl: 'https://picsum.photos/id/10/200/300',
        submissionCloseDate: DateTime.now(),
      );

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
