import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

const _textSample = [
  {'insert': 'Sample Rich Text Editor'},
  {
    'attributes': {'header': 1},
    'insert': '\n',
  },
  {'insert': '\n'},
  {'insert': 'We will be able to create content now!'},
  {'insert': '\n'},
];

class VoicesRichTextExample extends StatefulWidget {
  static const String route = '/rich-text-example';

  const VoicesRichTextExample({super.key});

  @override
  State<VoicesRichTextExample> createState() => _VoicesRichTextExampleState();
}

class _VoicesRichTextExampleState extends State<VoicesRichTextExample> {
  late final VoicesRichTextController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
      appBar: AppBar(title: const Text('Voices Rich Text')),
      body: SingleChildScrollView(
        child: VoicesRichText(
          controller: _controller,
          charsLimit: 800,
          focusNode: FocusNode(),
          scrollController: ScrollController(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = VoicesRichTextController(
      document: Document.fromJson(_textSample),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }
}
