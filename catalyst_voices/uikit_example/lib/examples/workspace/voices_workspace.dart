import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/workspace/proposal_navigation_panel.dart';
import 'package:uikit_example/examples/workspace/proposal_setup_panel.dart';
import 'package:uikit_example/examples/workspace/proposal_details.dart';
import 'package:uikit_example/examples/workspace/voices_workspace_drawer.dart';

final class ProposalSetupStep extends VoicesNodeMenuItem {
  final String desc;

  const ProposalSetupStep({
    required super.id,
    required String name,
    required this.desc,
  }) : super(label: name);

  /// Just syntax sugar. Semantically it makes more sense to have `name`.
  String get name => label;
}

const _proposalSetupSteps = [
  ProposalSetupStep(
    id: 0,
    name: 'Title',
    desc: 'Title',
  ),
  ProposalSetupStep(
    id: 1,
    name: 'Rich text',
    desc: 'Rich text',
  ),
  ProposalSetupStep(
    id: 2,
    name: 'Other topic',
    desc: 'Other topic',
  ),
  ProposalSetupStep(
    id: 3,
    name: 'Other topic',
    desc: 'Other topic',
  ),
];

class VoicesWorkspace extends StatefulWidget {
  static const String route = '/workspace';

  const VoicesWorkspace({
    super.key,
  });

  @override
  State<VoicesWorkspace> createState() => _VoicesWorkspaceState();
}

class _VoicesWorkspaceState extends State<VoicesWorkspace> {
  final _proposalSetupController = VoicesNodeMenuController(
    VoicesNodeMenuData(
      selectedItemId: _proposalSetupSteps.first.id,
      isExpanded: true,
    ),
  );

  @override
  void dispose() {
    _proposalSetupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeBuilder.buildTheme(BrandKey.catalyst),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: VoicesAppBar(
              backgroundColor:
                  Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
            ),
            drawer: VoicesWorkspaceDrawer(),
            body: SpaceScaffold(
              left: ProposalNavigationPanel(
                proposalSetupController: _proposalSetupController,
                proposalSetupItems: _proposalSetupSteps,
              ),
              right: ProposalSetupPanel(),
              child: ProposalDetails(
                proposalSetupController: _proposalSetupController,
                steps: _proposalSetupSteps,
              ),
            ),
          );
        },
      ),
    );
  }
}
