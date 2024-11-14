import 'package:catalyst_voices/widgets/navigation/section_step_state_builder.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkspaceRichTextStep extends StatelessWidget {
  final RichTextStep step;

  const WorkspaceRichTextStep({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return SectionStepStateBuilder(
      id: step.sectionStepId,
      builder: (context, value, child) {
        return WorkspaceTileContainer(
          isSelected: value.isSelected,
          content: child!,
        );
      },
      child: VoicesRichText(
        title: step.localizedDesc(context),
        document: Document.fromJson(step.data.value),
        charsLimit: step.charsLimit,
      ),
    );
  }
}
