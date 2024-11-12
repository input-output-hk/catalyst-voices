import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkspaceFormSection extends StatelessWidget {
  final WorkspaceSection data;

  const WorkspaceFormSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SectionExpandableTile<WorkspaceSection, RichTextStep>(
      section: data,
      stepBuilder: (context, step, state) {
        return _StepDetails(
          key: ValueKey('WorkspaceStep${step.id}TileKey'),
          step: step,
          isSelected: state.isSelected,
          isEditable: step.isEditable,
        );
      },
    );
  }
}

class _StepDetails extends StatelessWidget {
  final RichTextStep step;
  final bool isSelected;
  final bool isEditable;

  const _StepDetails({
    super.key,
    required this.step,
    this.isSelected = false,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return WorkspaceTileContainer(
      isSelected: isSelected,
      content: VoicesRichText(
        title: step.localizedDesc(context),
        document: Document.fromJson(step.data.value),
        charsLimit: step.charsLimit,
      ),
    );
  }
}
