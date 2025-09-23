import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  const factory CampaignRepository() = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    return Campaign.f14();
  }

  @override
  Future<CampaignCategory> getCategory(SignedDocumentRef ref) async {
    return Campaign.f14().categories.firstWhere(
      (e) => e.selfRef.id == ref.id,
      orElse: () => throw NotFoundException(
        message: 'Did not find category with ref $ref',
      ),
    );
  }
}
