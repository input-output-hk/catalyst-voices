import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/treasury_space/voices_treasury_space.dart';

class CampaignDetails extends StatelessWidget {
  final VoicesNodeMenuController campaignSetupController;
  final List<CampaignSetupStep> steps;

  const CampaignDetails({
    super.key,
    required this.campaignSetupController,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: [
        _ListenableCampaignSetupDetails(
          key: ValueKey('CampaignSetupDetailsKey'),
          controller: campaignSetupController,
          steps: steps,
        ),
      ],
    );
  }
}

class _ListenableCampaignSetupDetails extends StatelessWidget {
  final VoicesNodeMenuController controller;
  final List<CampaignSetupStep> steps;

  const _ListenableCampaignSetupDetails({
    super.key,
    required this.controller,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return _CampaignSetupDetails(
          campaignSetupSteps: steps,
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

class _CampaignSetupDetails extends StatelessWidget {
  final List<CampaignSetupStep> campaignSetupSteps;
  final int? selected;
  final bool isExpanded;
  final VoidCallback? onChevronTap;

  const _CampaignSetupDetails({
    required this.campaignSetupSteps,
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
          name: 'Setup Campaign',
          isHighlighted: isExpanded,
        ),
        if (isExpanded)
          ...campaignSetupSteps.map(
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
