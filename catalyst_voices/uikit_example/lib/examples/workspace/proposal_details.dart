import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/workspace/voices_workspace.dart';

class ProposalDetails extends StatelessWidget {
  final VoicesNodeMenuController proposalSetupController;
  final List<ProposalSetupStep> steps;

  const ProposalDetails({
    super.key,
    required this.proposalSetupController,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: [
        _ListenableProposalSetupDetails(
          key: ValueKey('ProposalSetupDetailsKey'),
          controller: proposalSetupController,
          steps: steps,
        ),
      ],
    );
  }
}

class _ListenableProposalSetupDetails extends StatelessWidget {
  final VoicesNodeMenuController controller;
  final List<ProposalSetupStep> steps;

  const _ListenableProposalSetupDetails({
    super.key,
    required this.controller,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return _ProposalSetupDetails(
          proposalSetupSteps: steps,
          selected: controller.value.selectedItemId,
          isExpanded: controller.value.isExpanded,
          onChevronTap: () {
            controller.isExpanded = !controller.value.isExpanded;
          },
        );
      },
    );
  }
}

class _ProposalSetupDetails extends StatelessWidget {
  final List<ProposalSetupStep> proposalSetupSteps;
  final int? selected;
  final bool isExpanded;
  final VoidCallback? onChevronTap;

  const _ProposalSetupDetails({
    required this.proposalSetupSteps,
    this.selected,
    this.isExpanded = false,
    this.onChevronTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SegmentHeader(
          leading: ChevronExpandButton(
            onTap: onChevronTap,
            isExpanded: isExpanded,
          ),
          name: 'Proposal setup',
          isHighlighted: isExpanded,
        ),
        if (isExpanded)
          ...proposalSetupSteps.map(
            (step) {
              return WorkspaceTileContainer(
                key: ValueKey('WorkspaceStep${step.id}TileKey'),
                isSelected: step.id == selected,
                name: step.name,
                headerActions: [
                  VoicesTextButton(child: Text('Edit')),
                ],
                content: Text(step.desc),
              );
            },
          )
      ].separatedBy(SizedBox(height: 12)).toList(),
    );
  }
}
