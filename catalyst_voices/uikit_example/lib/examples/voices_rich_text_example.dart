import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:flutter/material.dart';

class VoicesRichTextExample extends StatelessWidget {
  static const String route = '/rich-text-example';

  const VoicesRichTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Rich Text')),
      body: const VoicesRichText(),
    );
  }
}
