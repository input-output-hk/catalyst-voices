import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class CampaignService {
  const factory CampaignService(
    CampaignRepository campaignRepository,
    DocumentRepository documentRepository,
  ) = CampaignServiceImpl;

  Future<Campaign?> getActiveCampaign();

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  CampaignCategory getCategory(String uuid);

  Future<CurrentCampaign> getCurrentCampaign();
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;

  // ignore: unused_field
  final DocumentRepository _documentRepository;

  const CampaignServiceImpl(
    this._campaignRepository,
    this._documentRepository,
  );

  @override
  Future<Campaign?> getActiveCampaign() => getCampaign(id: 'F14');

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final campaignBase = await _campaignRepository.getCampaign(id: id);

    // TODO(damian-molinski): get proposalTemplateRef, document and map.

    final campaign = campaignBase.toCampaign();

    return campaign;
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    return staticCampaignCategories;
  }

  @override
  CampaignCategory getCategory(String uuid) {
    // TODO(LynxLynxx): call backend for current ask amount
    // and submitted proposal count
    return staticCampaignCategories.firstWhere(
      (e) => e.uuid == uuid,
      orElse: () => throw const NotFoundException(),
    );
  }

  @override
  Future<CurrentCampaign> getCurrentCampaign() async {
    // TODO(LynxLynxx): call backend for current ask amount
    return CurrentCampaignX.staticContent;
  }
}
