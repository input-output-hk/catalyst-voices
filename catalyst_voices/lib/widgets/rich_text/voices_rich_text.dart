import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/common/resizable_box_parent.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

/// A component for rich text writing
/// using Quill under the hood
/// https://pub.dev/packages/flutter_quill
class VoicesRichText extends StatefulWidget {
  final String title;
  final Document? document;
  final ValueChanged<Document>? onSave;
  final int? charsLimit;

  const VoicesRichText({
    super.key,
    this.title = '',
    this.document,
    this.onSave,
    this.charsLimit,
  });

  @override
  State<VoicesRichText> createState() => _VoicesRichTextState();
}

class _Editor extends StatelessWidget {
  final bool editMode;
  final QuillController controller;
  final FocusNode focusNode;

  const _Editor({
    required this.editMode,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ResizableBoxParent(
        minHeight: 400,
        resizableVertically: true,
        resizableHorizontally: false,
        child: Container(
          decoration: BoxDecoration(
            color: editMode
                ? Theme.of(context).colors.onSurfaceNeutralOpaqueLv1
                : Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: QuillEditor.basic(
            controller: controller,
            focusNode: focusNode,
            configurations: QuillEditorConfigurations(
              padding: const EdgeInsets.all(16),
              placeholder: context.l10n.placeholderRichText,
              embedBuilders: CatalystPlatform.isWeb
                  ? FlutterQuillEmbeds.editorWebBuilders()
                  : FlutterQuillEmbeds.editorBuilders(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final QuillController controller;
  final ValueChanged<Document>? onSave;

  const _Footer({
    required this.controller,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      alignment: Alignment.centerRight,
      color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
      child: VoicesFilledButton(
        child: Text(context.l10n.saveButtonText.toUpperCase()),
        onTap: () => onSave?.call(controller.document),
      ),
    );
  }
}

class _Limit extends StatelessWidget {
  final int documentLength;
  final int charsLimit;

  const _Limit({
    required this.documentLength,
    required this.charsLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.supportingTextLabelText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            '${documentLength}/${charsLimit}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final QuillController controller;

  const _Toolbar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
      child: QuillToolbar(
        configurations: const QuillToolbarConfigurations(),
        child: Row(
          children: [
            QuillToolbarIconButton(
              tooltip: context.l10n.headerTooltipText,
              onPressed: () {
                if (controller.isHeaderSelected) {
                  controller.formatSelection(Attribute.header);
                } else {
                  controller.formatSelection(Attribute.h1);
                }
              },
              icon: const Icon(CatalystVoicesIcons.rt_heading),
              isSelected: controller.isHeaderSelected,
              iconTheme: null,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                iconData: CatalystVoicesIcons.rt_bold,
              ),
              controller: controller,
              attribute: Attribute.bold,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                iconData: CatalystVoicesIcons.rt_italic,
              ),
              controller: controller,
              attribute: Attribute.italic,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                iconData: CatalystVoicesIcons.rt_ordered_list,
              ),
              controller: controller,
              attribute: Attribute.ol,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                iconData: CatalystVoicesIcons.rt_unordered_list,
              ),
              controller: controller,
              attribute: Attribute.ul,
            ),
            QuillToolbarIndentButton(
              options: QuillToolbarIndentButtonOptions(
                iconData: CatalystVoicesIcons.rt_increase_indent,
              ),
              controller: controller,
              isIncrease: true,
            ),
            QuillToolbarIndentButton(
              options: QuillToolbarIndentButtonOptions(
                iconData: CatalystVoicesIcons.rt_decrease_indent,
              ),
              controller: controller,
              isIncrease: false,
            ),
            QuillToolbarImageButton(
              options: const QuillToolbarImageButtonOptions(
                iconData: CatalystVoicesIcons.photograph,
              ),
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final bool editMode;
  final VoidCallback? onToggleEditMode;

  const _TopBar({
    required this.title,
    required this.editMode,
    this.onToggleEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Spacer(),
        VoicesTextButton(
          onTap: onToggleEditMode,
          child: Text(
            editMode
                ? context.l10n.cancelButtonText
                : context.l10n.editButtonText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}

class _VoicesRichTextState extends State<VoicesRichText> {
  final QuillController _controller = QuillController.basic();
  int _documentLength = 0;
  bool _editMode = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      excluding: !_editMode,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 20,
              bottom: 20,
            ),
            child: _TopBar(
              title: widget.title,
              editMode: _editMode,
              onToggleEditMode: () {
                setState(() {
                  _editMode = !_editMode;
                });
              },
            ),
          ),
          if (_editMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _Toolbar(controller: _controller),
            ),
          _Editor(
            editMode: _editMode,
            controller: _controller,
            focusNode: _focusNode,
          ),
          if (widget.charsLimit != null)
            _Limit(
              documentLength: _documentLength,
              charsLimit: widget.charsLimit!,
            ),
          SizedBox(height: 16),
          _Footer(
            controller: _controller,
            onSave: widget.onSave,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.document != null) _controller.document = widget.document!;
    _controller.document.changes.listen(_onDocumentChange);
    _documentLength = _controller.document.length;
  }

  void _onDocumentChange(DocChange docChange) {
    final documentLength = _controller.document.length;

    setState(() {
      _documentLength = documentLength;
    });

    final limit = widget.charsLimit;

    if (limit == null) return;

    if (documentLength > limit) {
      final latestIndex = limit - 1;
      _controller.replaceText(
        latestIndex,
        documentLength - limit,
        '',
        TextSelection.collapsed(offset: latestIndex),
      );
    }
  }
}

extension on QuillController {
  bool get isHeaderSelected {
    return getSelectionStyle().attributes.containsKey('header');
  }
}
