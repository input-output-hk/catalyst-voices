import 'package:catalyst_voices_models/catalyst_voices_models.dart';

// ignore: one_member_abstracts
abstract interface class CampaignRepository {
  const factory CampaignRepository() = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<CampaignTimeline> getCampaignTimeline();

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    return F14Campaign.staticContent;
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    return staticCampaignCategories;
  }

  @override
  Future<CampaignTimeline> getCampaignTimeline() async {
    return CampaignTimeline(phases: CampaignPhaseX.f14StaticContent);
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
}
