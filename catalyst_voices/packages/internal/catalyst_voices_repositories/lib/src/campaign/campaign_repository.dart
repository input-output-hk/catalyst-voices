import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class CampaignRepository {
  const factory CampaignRepository() = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<List<CampaignTimeline>> getCampaignTimeline();

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);

  Future<CurrentCampaign> getCurrentCampaign();
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final now = DateTime.now();

    return Campaign(
      id: id,
      name: 'Boost Social Entrepreneurship',
      description: 'We are currently only decentralizing our technology, '
          'failing to rethink how interactions play out in novel '
          'web3/p2p Action networks.',
      startDate: now.add(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 92)),
      proposalsCount: 0,
      publish: CampaignPublish.draft,
      categoriesCount: 0,
    );
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    return staticCampaignCategories;
  }

  @override
  Future<List<CampaignTimeline>> getCampaignTimeline() async {
    return CampaignTimelineX.staticContent;
  }

  @override
  Future<CampaignCategory> getCategory(SignedDocumentRef ref) async {
    return staticCampaignCategories.firstWhere(
      (e) => e.selfRef.id == ref.id,
      orElse: () => throw NotFoundException(
        message: 'Did not find category with ref $ref',
      ),
    );
  }

  @override
  Future<CurrentCampaign> getCurrentCampaign() async {
    return CurrentCampaignX.staticContent;
  }
}
