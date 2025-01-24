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
  final int availableFunds;
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
        availableFunds: 8000000,
        imageUrl: 'https://picsum.photos/id/10/200/300',
      );
}
