import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
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

class _VoicesRichTextState extends State<VoicesRichText> {
  final QuillController _controller = QuillController.basic();
  int _documentLength = 0;
  bool _editMode = false;
  Document _preEditDocument = Document();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            top: 20,
            bottom: 20,
          ),
          child: _TopBar(
            title: widget.title,
            editMode: _editMode,
            onToggleEditMode: () {
              setState(() {
                if (_editMode) {
                  _controller.document =
                      Document.fromDelta(_preEditDocument.toDelta());
                } else {
                  _preEditDocument =
                      Document.fromDelta(_controller.document.toDelta());
                }
                _editMode = !_editMode;
              });
            },
          ),
        ),
        if (_editMode)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
        const SizedBox(height: 16),
        if (_editMode)
          _Footer(
            controller: _controller,
            onSave: (document) {
              widget.onSave?.call(document);
              setState(() {
                _editMode = false;
              });
            },
          )
        else
          const SizedBox(height: 24),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // TODO(jakub): enable after implementing https://github.com/input-output-hk/catalyst-voices/issues/846
      // child: ResizableBoxParent(
      //   minHeight: 470,
      //   resizableVertically: true,
      //   resizableHorizontally: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: editMode
              ? Theme.of(context).colors.onSurfaceNeutralOpaqueLv1
              : Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IgnorePointer(
          ignoring: !editMode,
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
      // ),
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
        horizontal: 16,
        vertical: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.supportingTextLabelText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            '$documentLength/$charsLimit',
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
              icon: VoicesAssets.icons.rtHeading.buildIcon(),
              isSelected: controller.isHeaderSelected,
              iconTheme: null,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtBold,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.bold,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtItalic,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.italic,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtOrderedList,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.ol,
            ),
            QuillToolbarToggleStyleButton(
              options: QuillToolbarToggleStyleButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtUnorderedList,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              attribute: Attribute.ul,
            ),
            QuillToolbarIndentButton(
              options: QuillToolbarIndentButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtIncreaseIndent,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              isIncrease: true,
            ),
            QuillToolbarIndentButton(
              options: QuillToolbarIndentButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.rtDecreaseIndent,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
              isIncrease: false,
            ),
            QuillToolbarImageButton(
              options: QuillToolbarImageButtonOptions(
                childBuilder: (options, extraOptions) => _ToolbarIconButton(
                  icon: VoicesAssets.icons.photograph,
                  onPressed: extraOptions.onPressed,
                ),
              ),
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  final SvgGenImage icon;
  final VoidCallback? onPressed;

  const _ToolbarIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon.buildIcon(),
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
        const Spacer(),
        VoicesTextButton(
          onTap: onToggleEditMode,
          child: Text(
            editMode
                ? context.l10n.cancelButtonText
                : context.l10n.editButtonText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}

extension on QuillController {
  bool get isHeaderSelected {
    return getSelectionStyle().attributes.containsKey('header');
  }
}
