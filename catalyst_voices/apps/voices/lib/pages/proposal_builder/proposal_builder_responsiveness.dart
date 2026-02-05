import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_content.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_navigation_panel.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_setup_panel.dart';
import 'package:catalyst_voices/widgets/containers/sidebar/sidebar_scaffold.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices/widgets/tiles/specialized/document_builder_section_tile_controller.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ResponsiveProposalBuilderLayout extends StatelessWidget {
  final ItemScrollController segmentsScrollController;
  final DocumentBuilderSectionTileController sectionTileController;
  final VoidCallback onRetryTap;

  const ResponsiveProposalBuilderLayout({
    super.key,
    required this.segmentsScrollController,
    required this.sectionTileController,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveChild(
      sm: _SmallScreenProposalBuilderLayout(
        segmentsScrollController: segmentsScrollController,
        sectionTileController: sectionTileController,
        onRetryTap: onRetryTap,
      ),
      md: _MediumScreenProposalBuilderLayout(
        segmentsScrollController: segmentsScrollController,
        sectionTileController: sectionTileController,
        onRetryTap: onRetryTap,
      ),
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _MediumScreenProposalBuilderLayout extends StatelessWidget {
  final ItemScrollController segmentsScrollController;
  final DocumentBuilderSectionTileController sectionTileController;
  final VoidCallback onRetryTap;

  const _MediumScreenProposalBuilderLayout({
    required this.segmentsScrollController,
    required this.sectionTileController,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarScaffold(
      leftRail: const ProposalBuilderNavigationPanel(),
      rightRail: const ProposalBuilderSetupPanel(),
      body: ProposalBuilderContent(
        itemScrollController: segmentsScrollController,
        sectionTileController: sectionTileController,
        onRetryTap: onRetryTap,
      ),
      bodyConstraints: const BoxConstraints.expand(),
    );
  }
}

enum _ProposalBuilderTap {
  segmentsView,
  editorView,
  guidanceView,
}

class _SmallScreenProposalBuilderLayout extends StatefulWidget {
  final ItemScrollController segmentsScrollController;
  final DocumentBuilderSectionTileController sectionTileController;
  final VoidCallback onRetryTap;

  const _SmallScreenProposalBuilderLayout({
    required this.segmentsScrollController,
    required this.sectionTileController,
    required this.onRetryTap,
  });

  @override
  State<_SmallScreenProposalBuilderLayout> createState() =>
      _SmallScreenProposalBuilderLayoutState();
}

class _SmallScreenProposalBuilderLayoutState extends State<_SmallScreenProposalBuilderLayout>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: VoicesTabBar(
              tabAlignment: TabAlignment.center,
              tabs: [
                VoicesTab<_ProposalBuilderTap>(
                  data: _ProposalBuilderTap.segmentsView,
                  child: VoicesTabText(
                    context.l10n.treasuryCampaignBuilderSegments,
                  ),
                ),
                VoicesTab<_ProposalBuilderTap>(
                  data: _ProposalBuilderTap.editorView,
                  child: VoicesTabText(
                    context.l10n.editor,
                  ),
                ),
                VoicesTab<_ProposalBuilderTap>(
                  data: _ProposalBuilderTap.guidanceView,
                  child: VoicesTabText(
                    context.l10n.guidance,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                const _KeepAliveWrapper(
                  child: ProposalBuilderNavigationPanel(collapsable: false),
                ),
                _KeepAliveWrapper(
                  child: ProposalBuilderContent(
                    itemScrollController: widget.segmentsScrollController,
                    sectionTileController: widget.sectionTileController,
                    onRetryTap: widget.onRetryTap,
                  ),
                ),
                const _KeepAliveWrapper(
                  child: ProposalBuilderSetupPanel(collapsable: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
