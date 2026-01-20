import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_navigation_controls.dart';
import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_segments_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProposalNavigationPanel extends StatefulWidget {
  const ProposalNavigationPanel({super.key});

  @override
  State<ProposalNavigationPanel> createState() {
    return _ProposalNavigationPanelState();
  }
}

class _ProposalNavigationPanelState extends State<ProposalNavigationPanel> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SidebarPanel(
      isLeft: true,
      isCollapsed: _isCollapsed,
      header: ProposalNavigationControls(
        onToggleTap: _togglePanel,
        isCompact: _isCollapsed,
      ),
      body: const ProposalSegmentsNavigation(),
    );
  }

  void _togglePanel() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }
}
