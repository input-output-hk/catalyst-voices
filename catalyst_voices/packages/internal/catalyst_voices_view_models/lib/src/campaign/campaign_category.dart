import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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

final class CampaignCategoryCardViewModel extends CampaignCategory {
  final String subname;
  final String description;
  final int proposalsCount;
  final Coin availableFunds;
  final String imageUrl;

  const CampaignCategoryCardViewModel({
    required this.subname,
    required this.description,
    required this.proposalsCount,
    required this.availableFunds,
    required this.imageUrl,
    required super.id,
    required super.name,
  });

  factory CampaignCategoryCardViewModel.dummy() =>
      const CampaignCategoryCardViewModel(
        id: '1',
        name: 'Cardano Open:',
        subname: 'Developers',
        description:
            '''Supports development of open source technology, centered around improving the Cardano developer experience and creating developer-friendly tooling that streamlines an integrated development environment.''',
        proposalsCount: 263,
        availableFunds: Coin(8000000),
        imageUrl: 'https://picsum.photos/id/10/200/300',
      );

  String get availableFundsText {
    return CryptocurrencyFormatter.decimalFormat(availableFunds);
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
