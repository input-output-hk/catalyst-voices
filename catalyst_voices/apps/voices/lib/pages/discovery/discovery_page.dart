import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_hero.dart';
import 'package:catalyst_voices/pages/discovery/sections/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/campaign_categories_state_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/current_campaign_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/most_recent_proposals_selector.dart';
import 'package:catalyst_voices/widgets/banner/widgets/email_need_verification_banner.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_wide_screen_constrained.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DiscoveryPage extends StatefulWidget {
  final bool keychainDeleted;

  const DiscoveryPage({super.key, this.keychainDeleted = false});

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
            ].constrainedDelegate(
              excludePredicate: (widget) =>
                  widget is CampaignHeroSection ||
                  widget is MostRecentProposalsSelector ||
                  widget is HowItWorks,
            ),
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
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _Body(),
            ],
          ),
          EmailNeedVerificationBanner(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    unawaited(context.read<DiscoveryCubit>().getAllData());
    if (widget.keychainDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  Future<void> _showKeychainDeletedDialog(BuildContext context) async {
    await KeychainDeletedDialog.show(context);
  }
}
