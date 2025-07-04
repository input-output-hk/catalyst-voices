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
/// Global instance for [MarkdownCodec].
///
/// It's syntax sugar as const constructor works same way.
const markdown = MarkdownCodec();

final _deltaToMd = DeltaToMarkdown(
  customContentHandler: DeltaToMarkdown.escapeSpecialCharactersRelaxed,
);
final _mdDocument = md.Document();
final _mdToDelta = MarkdownToDelta(markdownDocument: _mdDocument);

/// In the app we support Quill's [Delta] format for rich text editor but for everything else
/// like communicating with backend or data models we're expecting Markdown String data
/// (enforced by [MarkdownData]).
///
/// This class provides utilities for converting between [MarkdownData] and [Delta].
final class MarkdownCodec extends Codec<MarkdownData, Delta> {
  const MarkdownCodec();

  @override
  Converter<Delta, MarkdownData> get decoder => const MarkdownEncoder();

  @override
  Converter<MarkdownData, Delta> get encoder => const MarkdownDecoder();
}

/// Decoder for [MarkdownCodec].
class MarkdownDecoder extends Converter<MarkdownData, Delta> {
  const MarkdownDecoder();

  @override
  Delta convert(MarkdownData input) {
    if (input.data.isEmpty) {
      return Delta();
    }

    return _mdToDelta.convert(input.data);
  }
}

/// Encoder for [MarkdownCodec].
class MarkdownEncoder extends Converter<Delta, MarkdownData> {
  const MarkdownEncoder();

  @override
  MarkdownData convert(Delta input) {
    if (input.isEmpty) {
      return const MarkdownData('');
    }

    final data = _deltaToMd.convert(input);
    final trimmed = data.trim();

    return MarkdownData(trimmed);
  }
}
