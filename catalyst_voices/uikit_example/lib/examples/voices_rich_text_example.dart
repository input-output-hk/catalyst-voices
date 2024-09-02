import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class VoicesRichTextExample extends StatelessWidget {
  static const String route = '/rich-text-example';

  const VoicesRichTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Rich Text')),
      body: SingleChildScrollView(
        child: VoicesRichText(
          document: Document.fromJson(_textSample),
          onSave: (document) => print('Saved document: $document'),
        ),
      ),
    );
  }
}

const _textSample = [
  {'insert': 'Sample Rich Text Editor'},
  {
    'attributes': {'header': 1},
    'insert': '\n'
  },
  {'insert': '\n'},
  {'insert': 'We will be able to create content now!'},
  {'insert': '\n'}
];
