import 'package:catalyst_voices_blocs/src/campaign/details/campaign_details.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class CampaignDetailsBloc
    extends Bloc<CampaignDetailsEvent, CampaignDetailsState> {
  final CampaignService _campaignService;

  CampaignDetailsBloc(
    this._campaignService,
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

    final campaign = await _campaignService.getCampaign(id: id);
    final listItems = _mapCampaignToListItems(campaign);

    emit(
      state.copyWith(
        title: Optional.of(campaign.name),
        listItems: listItems,
      ),
    );
  }

  List<CampaignListItem> _mapCampaignToListItems(Campaign campaign) {
    // TODO(damian-molinski): mapping of campaign is not ready.
    const sections = <CampaignCategorySection>[
      CampaignCategorySection(
        id: '1',
        category: CampaignCategory(id: '1', name: 'Concept'),
        title: 'Introduction',
        body: _tmpBody,
      ),
      CampaignCategorySection(
        id: '2',
        category: CampaignCategory(id: '2', name: 'Product'),
        title: 'Motivation',
        body: 'Different body here\n$_tmpBody',
      ),
    ];

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

const _tmpBody = '''
Open source software, hardware and data solutions encourage 
greater transparency and security, and help reduce costs by 
developing, collaborating, and fixing in the open. 
More information on open source can be found here.  

Cardano Open: Developers category supports developers and 
engineers to contribute to or develop open source technology 
centered around enabling and improving the Cardano developer 
experience. 

The goal of this category is to create developer-friendly 
tooling and approaches that streamline an integrated 
development environment, help to create code more 
efficiently, and provide an ease of use for developers to 
build on Cardano. 

Details of the selected open source license must be 
submitted by the applicants as part of their proposal. 

As part of their deliverables, projects will also be 
required to submit open source, high quality documentation 
for their technology that can be used as a 
learning resource by the rest of the community.''';
