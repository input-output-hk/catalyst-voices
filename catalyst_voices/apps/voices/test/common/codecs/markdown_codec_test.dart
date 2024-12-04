import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(MarkdownCodec, () {
    test('code and encode empty string', () {
      // Given
      const source = MarkdownString('');

      // When
      final delta = markdown.encode(source);
      final md = markdown.decode(delta);

      // Then
      expect(md, source);
    });

    test('code and encode plain text', () {
      // Given
      const source = MarkdownString('Hello Catalyst!');

      // When
      final delta = markdown.encode(source);
      final md = markdown.decode(delta);

      // Then
      expect(md, source);
    });

    group('decode', () {
      test('empty delta file builds empty string', () {
        // Given
        final delta = Delta();

        // When
        final markdownString = markdown.decode(delta);

        // Then
        expect(markdownString.data, isEmpty);
      });

      test('plan text delta file builds correct string', () {
        // Given
        const plainText = 'Hello Catalyst!';
        final delta = Delta()
          ..insert(plainText)
          ..insert('\n');

        // When
        final markdownString = markdown.decode(delta);

        // Then
        expect(markdownString.data, plainText);
      });
    });

    group('encode', () {
      test('empty markdown string builds valid empty delta', () {
        // Given
        const markdownString = MarkdownString('');

        // When
        final delta = markdown.encode(markdownString);

        // Then
        expect(delta.isEmpty, isTrue);
      });

      test('plan text markdown builds correct delta', () {
        // Given
        const plainText = 'Hello Catalyst!';
        const markdownString = MarkdownString(plainText);

        // When
        final delta = markdown.encode(markdownString);

        // Then
        expect(delta.isNotEmpty, isTrue);
        expect(delta.operations, hasLength(1));

        final operation = delta.operations[0];
        expect(operation.key, 'insert');
        expect(operation.data, '$plainText\n');
      });
    });
  });
}
