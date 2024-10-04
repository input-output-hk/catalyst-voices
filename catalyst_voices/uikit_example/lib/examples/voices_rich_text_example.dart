import 'dart:developer';

import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class VoicesRichTextExample extends StatelessWidget {
  static const String route = '/rich-text-example';

  const VoicesRichTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
      appBar: AppBar(title: const Text('Voices Rich Text')),
      body: SingleChildScrollView(
        child: VoicesRichText(
          title: 'Rich text',
          document: Document.fromJson(_textSample),
          charsLimit: 800,
          onSave: (document) => log('Saved document: $document'),
        ),
      ),
    );
  }
}

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
