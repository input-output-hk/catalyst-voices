import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

// Note.
// This codec is here because it depends on flutter_quill which is heavy
// package with lots different dependencies which we don't want to have in
// other packages.
//
// If we could have just Delta package it would be preferred to live in
// models/shared package
const markdown = MarkdownCodec();

final _mdDocument = md.Document();
final _mdToDelta = MarkdownToDelta(markdownDocument: _mdDocument);
final _deltaToMd = DeltaToMarkdown(
  customContentHandler: DeltaToMarkdown.escapeSpecialCharactersRelaxed,
);

final class MarkdownCodec extends Codec<MarkdownString, Delta> {
  const MarkdownCodec();

  @override
  Converter<Delta, MarkdownString> get decoder => const MarkdownEncoder();

  @override
  Converter<MarkdownString, Delta> get encoder => const MarkdownDecoder();
}

class MarkdownDecoder extends Converter<MarkdownString, Delta> {
  const MarkdownDecoder();

  @override
  Delta convert(MarkdownString input) {
    if (input.data.isEmpty) {
      return Delta();
    }

    return _mdToDelta.convert(input.data);
  }
}

class MarkdownEncoder extends Converter<Delta, MarkdownString> {
  const MarkdownEncoder();

  @override
  MarkdownString convert(Delta input) {
    if (input.isEmpty) {
      return const MarkdownString('');
    }

    final data = _deltaToMd.convert(input);
    final trimmed = data.trim();

    return MarkdownString(trimmed);
  }
}
