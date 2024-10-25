import 'package:catalyst_voices/pages/workspace/proposal_segment_controller.dart';
import 'package:catalyst_voices/pages/workspace/workspace_proposal_navigation_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ProposalDetails extends StatelessWidget {
  final WorkspaceProposalNavigation navigation;

  const ProposalDetails({
    super.key,
    required this.navigation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: navigation.segments.length,
      itemBuilder: (context, index) {
        final segment = navigation.segments[index];

        return _ListenableSegmentDetails(
          key: ValueKey('ListenableSegment${segment.id}DetailsKey'),
          segment: segment,
          controller: ProposalControllerScope.of(
            context,
            id: segment.id,
          ),
        );
      },
    );
  }
}

class _ListenableSegmentDetails extends StatelessWidget {
  final WorkspaceProposalSegment segment;
  final VoicesNodeMenuController controller;

  const _ListenableSegmentDetails({
    super.key,
    required this.segment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return _SegmentDetails(
          key: ValueKey('Segment${segment.id}DetailsKey'),
          name: segment.localizedName(context.l10n),
          steps: segment.steps,
          selected: controller.selected,
          isExpanded: controller.isExpanded,
          onChevronTap: () {
            controller.isExpanded = !controller.isExpanded;
          },
        );
      },
    );
  }
}

class _SegmentDetails extends StatelessWidget {
  final String name;
  final List<WorkspaceProposalSegmentStep> steps;
  final int? selected;
  final bool isExpanded;
  final VoidCallback? onChevronTap;

  const _SegmentDetails({
    super.key,
    required this.name,
    required this.steps,
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
          name: name,
          isSelected: isExpanded,
        ),
        if (isExpanded)
          ...steps.map(
            (step) {
              return _StepDetails(
                key: ValueKey('WorkspaceStep${step.id}TileKey'),
                id: step.id,
                title: step.title,
                titleInDetails: step.titleInDetails,
                desc: step.description,
                richTextParams: step.richTextParams,
                isSelected: step.id == selected,
                isEditable: step.isEditable,
              );
            },
          ),
        const SizedBox(height: 24),
      ].separatedBy(const SizedBox(height: 12)).toList(),
    );
  }
}

class _StepDetails extends StatelessWidget {
  const _StepDetails({
    super.key,
    required this.id,
    required this.title,
    this.titleInDetails,
    this.desc,
    this.richTextParams,
    this.isSelected = false,
    this.isEditable = false,
  });

  final int id;
  final String title;
  final String? titleInDetails;
  final String? desc;
  final RichTextParams? richTextParams;
  final bool isSelected;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    if (desc != null) {
      return WorkspaceTextTileContainer(
        name: titleInDetails != null ? titleInDetails! : title,
        isSelected: isSelected,
        headerActions: [
          TextButton(
            onPressed: isEditable ? () {} : null,
            child: Text(
              context.l10n.stepEdit,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
        content: desc!,
      );
    } else if (richTextParams != null) {
      return WorkspaceTileContainer(
        isSelected: isSelected,
        content: VoicesRichText(
          title: titleInDetails != null ? titleInDetails! : title,
          document: Document.fromJson(richTextParams!.documentJson.value),
          charsLimit: richTextParams!.charsLimit,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
