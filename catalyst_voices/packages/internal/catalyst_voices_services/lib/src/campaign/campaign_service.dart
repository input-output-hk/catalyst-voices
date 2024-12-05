import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class CampaignService {
  factory CampaignService(
    CampaignRepository campaignRepository,
  ) {
    return CampaignServiceImpl(
      campaignRepository,
    );
  }

  Future<bool> isAnyCampaignActive();

  Future<Campaign?> getActiveCampaign();
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;

  const CampaignServiceImpl(
    this._campaignRepository,
  );

  @override
  Future<bool> isAnyCampaignActive() async {
    return true;
  }

  @override
  Future<Campaign?> getActiveCampaign() async {
    final campaign = await _campaignRepository.getCampaign(id: 'F14');

    return campaign;
  }
}
