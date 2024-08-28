import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

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
        QuillToolbar.simple(
          configurations:
              QuillSimpleToolbarConfigurations(controller: _controller),
        ),
        Expanded(
          child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,

              padding: const EdgeInsets.all(16),
              placeholder: 'Start writing your text...'
            ),
          ),
        )
      ],
    );
  }
}
