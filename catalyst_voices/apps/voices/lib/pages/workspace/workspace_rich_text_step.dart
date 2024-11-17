import 'package:catalyst_voices/widgets/navigation/section_step_state_builder.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkspaceRichTextStep extends StatefulWidget {
  final RichTextStep step;

  const WorkspaceRichTextStep({
    super.key,
    required this.step,
  });

  @override
  State<WorkspaceRichTextStep> createState() => _WorkspaceRichTextStepState();
}

class _WorkspaceRichTextStepState extends State<WorkspaceRichTextStep> {
  late final VoicesRichTextController _controller;
  late final VoicesRichTextEditModeController _editModeController;

  @override
  void initState() {
    super.initState();

    final document = Document.fromJson(widget.step.data.value);
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
        return WorkspaceTileContainer(
          isSelected: value.isSelected,
          content: child!,
        );
      },
      child: VoicesRichText(
        title: widget.step.localizedDesc(context),
        controller: _controller,
        editModeController: _editModeController,
        charsLimit: widget.step.charsLimit,
        canEditDocumentGetter: _canEditDocument,
        onEditBlocked: _showEditBlockedRationale,
      ),
    );
  }

  bool _canEditDocument(Document document) {
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
