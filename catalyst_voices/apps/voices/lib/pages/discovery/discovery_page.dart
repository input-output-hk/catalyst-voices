import 'dart:async';

import 'package:catalyst_voices/pages/discovery/sections/campaign_hero.dart';
import 'package:catalyst_voices/pages/discovery/sections/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/campaign_categories_state_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/current_campaign_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/most_recent_proposals_selector.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();

    unawaited(context.read<DiscoveryCubit>().getAllData());
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _Body(),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const CampaignHeroSection(),
              const HowItWorks(),
              const CurrentCampaignSelector(),
              const CampaignCategoriesStateSelector(),
              const MostRecentProposalsSelector(),

            ],
          ),
        ),
      ],
    );
  }
}
