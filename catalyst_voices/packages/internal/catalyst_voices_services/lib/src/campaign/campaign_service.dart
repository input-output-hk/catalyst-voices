import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class CampaignService {
  factory CampaignService(
    CampaignRepository campaignRepository,
    DocumentRepository documentRepository,
  ) = CampaignServiceImpl;

  Future<Campaign?> getActiveCampaign();

  Future<Campaign> getCampaign({required String id});
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;
  final DocumentRepository _documentRepository;

  const CampaignServiceImpl(
    this._campaignRepository,
    this._documentRepository,
  );

  @override
  Future<Campaign?> getActiveCampaign() => getCampaign(id: 'F14');

  @override
  Future<Campaign> getCampaign({required String id}) async {
    final campaignBase = await _campaignRepository.getCampaign(id: id);

    final documentId = campaignBase.proposalTemplateId;
    final documentSchema = await _documentRepository.getDocumentSchema(
      documentId,
    );

    final campaign = campaignBase.toCampaign(proposalTemplate: documentSchema);

    return campaign;
  }
}
