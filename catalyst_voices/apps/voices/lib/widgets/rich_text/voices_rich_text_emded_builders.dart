import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DebugUnknownEmbedBuilder extends quill.EmbedBuilder {
  const DebugUnknownEmbedBuilder();

  @override
  String get key => 'unknown';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    return Text(
      'Unsupported type: ${embedContext.node.value.type}',
      style: const TextStyle(fontSize: 32, color: Colors.red),
    );
  }
}

class DividerEmbedBuilder extends quill.EmbedBuilder {
  const DividerEmbedBuilder();

  @override
  String get key => 'divider';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    return const Divider(
      height: 20,
      thickness: 5,
      indent: 0,
      endIndent: 0,
    );
  }
}

class UnknownEmbedBuilder extends quill.EmbedBuilder {
  const UnknownEmbedBuilder();

  @override
  String get key => 'unknown';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    return const SizedBox.shrink();
  }
}
