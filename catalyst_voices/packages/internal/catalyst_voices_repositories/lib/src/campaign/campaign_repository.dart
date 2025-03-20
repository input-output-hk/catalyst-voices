import 'package:catalyst_voices_models/catalyst_voices_models.dart';

// ignore: one_member_abstracts
abstract interface class CampaignRepository {
  factory CampaignRepository() = CampaignRepositoryImpl;

  Future<CampaignBase> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);

  Future<CurrentCampaign> getCurrentCampaign();
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<CampaignBase> getCampaign({
    required String id,
  }) async {
    final now = DateTime.now();

    return CampaignBase(
      id: id,
      name: 'Boost Social Entrepreneurship',
      description: 'We are currently only decentralizing our technology, '
          'failing to rethink how interactions play out in novel '
          'web3/p2p Action networks.',
      startDate: now.add(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 92)),
      proposalsCount: 0,
      publish: CampaignPublish.draft,
    );
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    return staticCampaignCategories;
  }

  @override
  Future<CampaignCategory> getCategory(SignedDocumentRef ref) async {
    return staticCampaignCategories.firstWhere(
      (e) => e.selfRef == ref,
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
