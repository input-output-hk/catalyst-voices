import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_categories_tile.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_details_tile.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignSectionsListView extends StatelessWidget {
  const CampaignSectionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignDetailsBloc, CampaignDetailsState,
        List<CampaignListItem>>(
      selector: (state) => state.listItems,
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.length,
          itemBuilder: (context, index) {
            final item = state[index];

            switch (item) {
              case CampaignDetailsListItem():
                return CampaignDetailsTile(
                  description: item.description,
                  startDate: item.startDate,
                  endDate: item.endDate,
                  categoriesCount: item.categoriesCount,
                  proposalsCount: item.proposalsCount,
                );
              case CampaignCategoriesListItem():
                return CampaignCategoriesTile(
                  sections: item.sections,
                );
            }
          },
        );
      },
    );
  }
}
