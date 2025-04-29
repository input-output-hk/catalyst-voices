import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// ignore: one_member_abstracts
abstract interface class CampaignRepository {
  const factory CampaignRepository(
    ProposalRepository proposalRepository,
  ) = CampaignRepositoryImpl;

  Future<CampaignBase> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<List<CampaignTimeline>> getCampaignTimeline();

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);

  Future<CurrentCampaign> getCurrentCampaign();
}

final class CampaignRepositoryImpl implements CampaignRepository {
  final ProposalRepository _proposalRepository;

  const CampaignRepositoryImpl(
    this._proposalRepository,
  );

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
    final categories = <CampaignCategory>[];
    final staticCategories = staticCampaignCategories;
    for (final category in staticCategories) {
      final categoryProposals = await _proposalRepository.getProposals(
        type: ProposalsFilterType.finals,
        categoryRef: category.selfRef,
      );
      final totalAsk = _calculateTotalAsk(categoryProposals);

      final updatedCategory = category.copyWith(
        totalAsk: totalAsk,
        proposalsCount: categoryProposals.length,
      );
      categories.add(updatedCategory);
    }
    return categories;
  }

  @override
  Future<List<CampaignTimeline>> getCampaignTimeline() async {
    return CampaignTimelineX.staticContent;
  }

  @override
  Future<CampaignCategory> getCategory(SignedDocumentRef ref) async {
    final staticCategory = staticCampaignCategories.firstWhere(
      (e) => e.selfRef.id == ref.id,
      orElse: () => throw NotFoundException(
        message: 'Did not find category with ref $ref',
      ),
    );
    final categoryProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
      categoryRef: ref,
    );
    final totalAsk = _calculateTotalAsk(categoryProposals);

    final category = staticCategory.copyWith(
      totalAsk: totalAsk,
      proposalsCount: categoryProposals.length,
    );
    return category;
  }

  @override
  Future<CurrentCampaign> getCurrentCampaign() async {
    final campaignProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
    );
    final totalAsk = _calculateTotalAsk(campaignProposals);

    return CurrentCampaignX.staticContent.copyWith(totalAsk: totalAsk.ada);
  }

  Coin _calculateTotalAsk(List<ProposalData> proposals) {
    var totalAskBalance = const Balance.zero();
    for (final proposal in proposals) {
      final requested =
          Balance(coin: proposal.document.fundsRequested ?? const Coin(0));

      totalAskBalance += requested;
    }
    return totalAskBalance.coin;
  }
}
