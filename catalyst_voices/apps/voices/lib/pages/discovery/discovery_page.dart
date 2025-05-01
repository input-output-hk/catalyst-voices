import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_hero.dart';
import 'package:catalyst_voices/pages/discovery/sections/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/campaign_categories_state_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/current_campaign_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/most_recent_proposals_selector.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DiscoveryPage extends StatefulWidget {
  final bool _keychainDeleted;

  const DiscoveryPage({super.key}) : _keychainDeleted = false;
  const DiscoveryPage.keychainDeleted({super.key}) : _keychainDeleted = true;

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
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
              const StayInvolved(),
              const MostRecentProposalsSelector(),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with ErrorHandlerStateMixin<DiscoveryCubit, DiscoveryPage> {
  @override
  Widget build(BuildContext context) {
    return const SelectionArea(
      child: CustomScrollView(
        slivers: [
          _Body(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    unawaited(context.read<DiscoveryCubit>().getAllData());

    if (widget._keychainDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  Future<void> _showKeychainDeletedDialog(BuildContext context) async {
    await KeychainDeletedDialog.show(context);
  }
}
