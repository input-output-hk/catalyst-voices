import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  static CurrentCampaign? _currentCampaign;

  /// Overrides the current campaign returned by [getCurrentCampaign].
  /// Only for unit testing.
  @visibleForTesting
  //ignore: avoid_setters_without_getters
  static set currentCampaign(CurrentCampaign? currentCampaign) {
    _currentCampaign = currentCampaign;
  }

  const factory CampaignRepository() = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<List<CampaignTimeline>> getCampaignTimeline();

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);

  Future<CurrentCampaign> getCurrentCampaign();
}

final class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final now = DateTimeExt.now();

    return Campaign(
      id: id,
      name: 'Boost Social Entrepreneurship',
      description: 'We are currently only decentralizing our technology, '
          'failing to rethink how interactions play out in novel '
          'web3/p2p Action networks.',
      startDate: now.add(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 92)),
      proposalsCount: 0,
      publish: CampaignPublish.draft,
      categoriesCount: 0,
    );
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    return staticCampaignCategories;
  }

  @override
  Future<List<CampaignTimeline>> getCampaignTimeline() {
    return getCurrentCampaign().then((value) => value.timeline);
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

  @override
  Future<CurrentCampaign> getCurrentCampaign() async {
    return CampaignRepository._currentCampaign ?? CurrentCampaignX.staticContent;
  }
}
