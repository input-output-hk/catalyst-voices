import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:uuid/uuid.dart';

// ignore: one_member_abstracts
abstract interface class CampaignRepository {
  factory CampaignRepository() = CampaignRepositoryImpl;

  Future<CampaignBase> getCampaign({required String id});
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<CampaignBase> getCampaign({required String id}) async {
    final now = DateTime.now();
    final proposalTemplateId = const Uuid().v7();

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
      proposalTemplateId: proposalTemplateId,
    );
  }
}
