import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  const factory CampaignRepository() = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignCategory?> getCategory(SignedDocumentRef ref);

  Future<CampaignCategory?> getCategoryWithParameters(DocumentParameters parameters);
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    if (id == Campaign.f15Ref.id) {
      return Campaign.f15();
    }
    if (id == Campaign.f14Ref.id) {
      return Campaign.f14();
    }
    throw NotFoundException(message: 'Campaign $id not found');
  }

  @override
  Future<CampaignCategory?> getCategory(SignedDocumentRef ref) async {
    return Campaign.all
        .expand((element) => element.categories)
        .firstWhereOrNull((e) => e.selfRef.id == ref.id);
  }

  @override
  Future<CampaignCategory?> getCategoryWithParameters(DocumentParameters parameters) async {
    return Campaign.all
        .expand((element) => element.categories)
        .firstWhereOrNull((e) => parameters.containsId(e.selfRef.id));
  }
}
