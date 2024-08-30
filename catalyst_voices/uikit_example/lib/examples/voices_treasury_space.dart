import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesTreasurySpace extends StatelessWidget {
  static const String route = '/treasury-space';

  const VoicesTreasurySpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(
        backgroundColor: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
      ),
      drawer: const VoicesDrawer(children: []),
      body: const SpaceContainer(
        left: _CampaignBuilderPanel(),
        right: _CampaignCommentsPanel(),
        child: _ContentBody(),
      ),
    );
  }
}

class _CampaignBuilderPanel extends StatelessWidget {
  const _CampaignBuilderPanel();

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: 'Campaign builder',
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Segments',
          body: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(border: Border.all()),
                position: DecorationPosition.foreground,
                child: VoicesNodeMenu(
                  name: 'Setup Campaign',
                  selected: 0,
                  items: [
                    VoicesNodeMenuItem(id: 0, label: 'Other topic 1'),
                    VoicesNodeMenuItem(id: 1, label: 'Other topic 2'),
                    VoicesNodeMenuItem(id: 2, label: 'Other topic 3'),
                  ],
                  onSelectionChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CampaignCommentsPanel extends StatelessWidget {
  const _CampaignCommentsPanel();

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: 'Campaign comments',
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Comments',
          body: Offstage(),
        ),
      ],
    );
  }
}

class _ContentBody extends StatelessWidget {
  const _ContentBody();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) {
        if (index.isOdd) return const SizedBox(height: 16);

        return Container(
          height: 128,
          decoration: BoxDecoration(
            color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
            borderRadius: BorderRadius.circular(28),
          ),
          alignment: Alignment.center,
          child: Text(index.toString()),
        );
      },
    );
  }
}
