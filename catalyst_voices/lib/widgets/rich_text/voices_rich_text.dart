import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

/// A component for rich text writing
/// using Quill under the hood
/// https://pub.dev/packages/flutter_quill
class VoicesRichText extends StatefulWidget {
  const VoicesRichText({super.key});

  @override
  State<VoicesRichText> createState() => _VoicesRichTextState();
}

class _VoicesRichTextState extends State<VoicesRichText> {
  final QuillController _controller = QuillController.basic();

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
        Expanded(
          child: QuillEditor.basic(
            controller: _controller,
            configurations: QuillEditorConfigurations(
              padding: const EdgeInsets.all(16),
              placeholder: 'Start writing your text...',
              embedBuilders: FlutterQuillEmbeds.editorWebBuilders(),
            ),
          ),
        ),
      ],
    );
  }
}
