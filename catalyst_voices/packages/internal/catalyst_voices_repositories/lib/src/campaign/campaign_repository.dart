import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  const factory CampaignRepository() = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignCategory?> getCategory(DocumentParameters parameters);
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    for (final campaign in Campaign.all) {
      if (id == campaign.selfRef.id) {
        return campaign;
      }
    }
    throw NotFoundException(message: 'Campaign $id not found');
  }

  @override
  Future<CampaignCategory?> getCategory(DocumentParameters parameters) async {
    return Campaign.all
        .expand((element) => element.categories)
        .firstWhereOrNull((e) => parameters.containsId(e.selfRef.id));
  }
}
