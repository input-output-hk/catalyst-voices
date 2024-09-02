import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/common/resizable_box_parent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

/// A component for rich text writing
/// using Quill under the hood
/// https://pub.dev/packages/flutter_quill
class VoicesRichText extends StatefulWidget {
  const VoicesRichText({
    super.key,
    required this.document,
    this.onSave,
    this.charsLimit,
  });

  final Document document;
  final ValueChanged<Document>? onSave;
  final int? charsLimit;

  @override
  State<VoicesRichText> createState() => _VoicesRichTextState();
}

class _VoicesRichTextState extends State<VoicesRichText> {
  final QuillController _controller = QuillController.basic();

  void _onDocumentChange(DocChange docChange) {
    final documentLength = _controller.document.length;
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
    _controller.document = widget.document;
    _controller.document.changes.listen(_onDocumentChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar(
          configurations: const QuillToolbarConfigurations(),
          child: Row(
            children: [
              QuillToolbarIconButton(
                tooltip: 'Header',
                onPressed: () {
                  if (_controller.getSelectionStyle().attributes['header'] ==
                      null) {
                    _controller.formatSelection(Attribute.h1);
                  } else {
                    _controller.formatSelection(Attribute.header);
                  }
                },
                icon: Text('H'),
                isSelected:
                    _controller.getSelectionStyle().attributes['header'] !=
                        null,
                iconTheme: null,
              ),
              QuillToolbarSelectHeaderStyleDropdownButton(
                controller: _controller,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: _controller,
                attribute: Attribute.bold,
              ),
              QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(),
                controller: _controller,
                attribute: Attribute.italic,
              ),
              QuillToolbarToggleStyleButton(
                controller: _controller,
                attribute: Attribute.ol,
              ),
              QuillToolbarToggleStyleButton(
                controller: _controller,
                attribute: Attribute.ul,
                //options: QuillToolbarToggleStyleButtonOptions(iconData: Icons.abc),
              ),
              QuillToolbarIndentButton(
                controller: _controller,
                isIncrease: true,
              ),
              QuillToolbarIndentButton(
                controller: _controller,
                isIncrease: false,
              ),
              QuillToolbarImageButton(
                controller: _controller,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ResizableBoxParent(
            minHeight: 400,
            resizable: true,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: QuillEditor.basic(
                controller: _controller,
                configurations: QuillEditorConfigurations(
                  padding: const EdgeInsets.all(16),
                  placeholder: 'Start writing your text...',
                  embedBuilders: FlutterQuillEmbeds.editorWebBuilders(),
                ),
              ),
            ),
          ),
        ),
        VoicesFilledButton(
          child: Text('Save'),
          onTap: () => widget.onSave?.call(_controller.document),
        ),
      ],
    );
  }
}
