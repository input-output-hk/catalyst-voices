import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

class CampaignService {
  final CampaignRepository _campaignRepository;

  const CampaignService(this._campaignRepository);

  Future<Campaign?> getActiveCampaign() {
    // TODO(dtscalac): replace by api call
    return _campaignRepository.getCampaign(id: 'F14');
  }
}
