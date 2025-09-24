import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class CampaignDatesStateSelector extends StatelessWidget {
  final DataWidgetBuilder<CampaignDatesEventsState> builder;

  const CampaignDatesStateSelector({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, CampaignDatesEventsState>(
      selector: (state) => state.campaign.datesEvents,
      builder: builder,
    );
  }
}
