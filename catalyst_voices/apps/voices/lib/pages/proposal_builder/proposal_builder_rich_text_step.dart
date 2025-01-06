import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices/widgets/navigation/section_step_state_builder.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ProposalBuilderRichTextStep extends StatefulWidget {
  final RichTextStep step;

  const ProposalBuilderRichTextStep({
    super.key,
    required this.step,
  });

  @override
  State<ProposalBuilderRichTextStep> createState() {
    return _ProposalBuilderRichTextStepState();
  }
}

class _ProposalBuilderRichTextStepState
    extends State<ProposalBuilderRichTextStep> {
  late final VoicesRichTextController _controller;
  late final VoicesRichTextEditModeController _editModeController;

  @override
  void initState() {
    super.initState();

    final markdownString = widget.step.initialData ?? const MarkdownData('');
    final delta = markdown.encode(markdownString);

    final document =
        delta.isNotEmpty ? quill.Document.fromDelta(delta) : quill.Document();
    final selectionOffset = document.length == 0 ? 0 : document.length - 1;

    _controller = VoicesRichTextController(
      document: document,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
    _editModeController = VoicesRichTextEditModeController();
    _editModeController.addListener(_onEditModeControllerChanged);
  }

  @override
  void dispose() {
    _editModeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionStepStateBuilder(
      id: widget.step.sectionStepId,
      builder: (context, value, child) {
        return SelectableTile(
          isSelected: value.isSelected,
          child: child!,
        );
      },
      child: VoicesRichText(
        title: widget.step.description ?? widget.step.name,
        controller: _controller,
        editModeController: _editModeController,
        charsLimit: widget.step.charsLimit,
        canEditDocumentGetter: _canEditDocument,
        onEditBlocked: _showEditBlockedRationale,
        onSaved: _saveDocument,
      ),
    );
  }

  void _saveDocument(quill.Document document) {
    final delta = document.toDelta();
    final markdownString = markdown.decode(delta);

    final sectionStepId = widget.step.sectionStepId;

    final event = UpdateStepAnswerEvent(
      id: sectionStepId,
      data: markdownString.data.isNotEmpty ? markdownString : null,
    );

    context.read<ProposalBuilderBloc>().add(event);
  }

  bool _canEditDocument(quill.Document document) {
    final sectionsController = SectionsControllerScope.of(context);

    final ids = sectionsController.value.editStepsIds;
    final isEditing = ids.isNotEmpty;

    return !isEditing;
  }

  Future<void> _showEditBlockedRationale() async {
    await VoicesDialog.show<void>(
      context: context,
      builder: (context) {
        return VoicesAlertDialog(
          title: Text(context.l10n.warning),
          subtitle: Text(context.l10n.saveBeforeEditingErrorText),
          buttons: [
            VoicesFilledButton(
              child: Text(context.l10n.ok),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _onEditModeControllerChanged() {
    final isEditMode = _editModeController.value;
    final sectionsController = SectionsControllerScope.of(context);
    final id = widget.step.sectionStepId;

    sectionsController.editStep(id, enabled: isEditMode);
  }
}
