import 'dart:convert';

import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Encoder for [MarkdownData] to a plain [String].
///
/// Strips the markdown from any formatting and just returns the plain string,
/// useful for voice readers, etc.
class MarkdownToPlainStringEncoder extends Converter<MarkdownData, String> {
  const MarkdownToPlainStringEncoder();

  @override
  String convert(MarkdownData input) {
    final delta = markdown.encode(input);
    final document = quill.Document.fromDelta(delta);
    final result = document.toPlainText(
      [],
      _EmptyEmbedBuilder(),
    );

    return result.trim();
  }
}

class _EmptyEmbedBuilder extends quill.EmbedBuilder {
  @override
  String get key => throw UnsupportedError(
    'We only need toPlainText() from this builder, key should never be used.',
  );

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    throw UnsupportedError(
      'We only need toPlainText() from this builder, build() should never be used.',
    );
  }

  @override
  String toPlainText(quill.Embed node) => '';
}
