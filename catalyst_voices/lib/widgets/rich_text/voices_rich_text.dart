import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/common/resizable_box_parent.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

/// A component for rich text writing
/// using Quill under the hood
/// https://pub.dev/packages/flutter_quill
class VoicesRichText extends StatefulWidget {
  const VoicesRichText({
    super.key,
    this.document,
    this.onSave,
    this.charsLimit,
  });

  final Document? document;
  final ValueChanged<Document>? onSave;
  final int? charsLimit;

  @override
  State<VoicesRichText> createState() => _VoicesRichTextState();
}

class _VoicesRichTextState extends State<VoicesRichText> {
  final QuillController _controller = QuillController.basic();
  int _documentLength = 0;
  bool _editMode = false;
  FocusNode _focusNode = FocusNode();

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

  @override
  void initState() {
    super.initState();
    if (widget.document != null) _controller.document = widget.document!;
    _controller.document.changes.listen(_onDocumentChange);

    setState(() {
      _documentLength = _controller.document.length;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      excluding: !_editMode,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 20, bottom: 20),
            child: Row(
              children: [
                Text(
                  'Rich text',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _editMode = !_editMode;
                          });
                        },
                        child: Text(
                          _editMode ? 'Cancel' : 'Edit',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_editMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
                child: QuillToolbar(
                  configurations: const QuillToolbarConfigurations(),
                  child: Row(
                    children: [
                      QuillToolbarIconButton(
                        tooltip: 'Header',
                        onPressed: () {
                          if (_controller
                                  .getSelectionStyle()
                                  .attributes['header'] ==
                              null) {
                            _controller.formatSelection(Attribute.h1);
                          } else {
                            _controller.formatSelection(Attribute.header);
                          }
                        },
                        icon: const Icon(CatalystVoicesIcons.rt_heading),
                        isSelected: _controller
                                .getSelectionStyle()
                                .attributes['header'] !=
                            null,
                        iconTheme: null,
                      ),
                      QuillToolbarToggleStyleButton(
                        options: const QuillToolbarToggleStyleButtonOptions(
                          iconData: CatalystVoicesIcons.rt_bold,
                        ),
                        controller: _controller,
                        attribute: Attribute.bold,
                      ),
                      QuillToolbarToggleStyleButton(
                        options: const QuillToolbarToggleStyleButtonOptions(
                          iconData: CatalystVoicesIcons.rt_italic,
                        ),
                        controller: _controller,
                        attribute: Attribute.italic,
                      ),
                      QuillToolbarToggleStyleButton(
                        options: const QuillToolbarToggleStyleButtonOptions(
                          iconData: CatalystVoicesIcons.rt_ordered_list,
                        ),
                        controller: _controller,
                        attribute: Attribute.ol,
                      ),
                      QuillToolbarToggleStyleButton(
                        options: const QuillToolbarToggleStyleButtonOptions(
                          iconData: CatalystVoicesIcons.rt_unordered_list,
                        ),
                        controller: _controller,
                        attribute: Attribute.ul,
                        //options: QuillToolbarToggleStyleButtonOptions(iconData: Icons.abc),
                      ),
                      QuillToolbarIndentButton(
                        options: QuillToolbarIndentButtonOptions(
                          iconData: CatalystVoicesIcons.rt_increase_indent,
                        ),
                        controller: _controller,
                        isIncrease: true,
                      ),
                      QuillToolbarIndentButton(
                        options: QuillToolbarIndentButtonOptions(
                          iconData: CatalystVoicesIcons.rt_decrease_indent,
                        ),
                        controller: _controller,
                        isIncrease: false,
                      ),
                      QuillToolbarImageButton(
                        options: const QuillToolbarImageButtonOptions(
                          iconData: CatalystVoicesIcons.photograph,
                        ),
                        controller: _controller,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ResizableBoxParent(
              minHeight: 400,
              resizable: true,
              child: Container(
                decoration: BoxDecoration(
                  color: _editMode
                      ? Theme.of(context).colors.onSurfaceNeutralOpaqueLv1
                      : Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: QuillEditor.basic(
                  controller: _controller,
                  focusNode: _focusNode,
                  configurations: QuillEditorConfigurations(
                    padding: const EdgeInsets.all(16),
                    placeholder: 'Start writing your text...',
                    embedBuilders: isWeb()
                        ? FlutterQuillEmbeds.editorWebBuilders()
                        : FlutterQuillEmbeds.editorBuilders(),
                  ),
                ),
              ),
            ),
          ),
          if (widget.charsLimit != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Supporting text',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    '${_documentLength}/${widget.charsLimit!}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            alignment: Alignment.centerRight,
            color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
            child: VoicesFilledButton(
              child: Text('Save'.toUpperCase()),
              onTap: () => widget.onSave?.call(_controller.document),
            ),
          ),
        ],
      ),
    );
  }
}
