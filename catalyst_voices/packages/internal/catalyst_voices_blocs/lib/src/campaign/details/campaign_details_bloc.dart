import 'package:catalyst_voices_blocs/src/campaign/details/campaign_details.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class CampaignDetailsBloc
    extends Bloc<CampaignDetailsEvent, CampaignDetailsState> {
  final CampaignRepository _campaignRepository;

  CampaignDetailsBloc(
    this._campaignRepository,
  ) : super(const CampaignDetailsState()) {
    on<LoadCampaignEvent>(_onLoadCampaignEvent);
  }

  Future<void> _onLoadCampaignEvent(
    LoadCampaignEvent event,
    Emitter<CampaignDetailsState> emit,
  ) async {
    final id = event.id;

    emit(
      state.copyWith(
        title: const Optional.empty(),
        listItems: const [],
      ),
    );

    final campaign = await _campaignRepository.getCampaign(id: id);
    final listItems = _mapCampaignToListItems(campaign);

    emit(
      state.copyWith(
        title: Optional.of(campaign.name),
        listItems: listItems,
      ),
    );
  }

  List<CampaignListItem> _mapCampaignToListItems(Campaign campaign) {
    final sections =
        campaign.sections.map(CampaignCategorySection.fromCategory).toList();

    return [
      CampaignDetailsListItem(
        description: campaign.description,
        startDate: campaign.startDate,
        endDate: campaign.endDate,
        proposalsCount: campaign.proposalsCount,
        categoriesCount: campaign.categoriesCount,
      ),
      CampaignCategoriesListItem(sections: sections),
    ];
  }
}
