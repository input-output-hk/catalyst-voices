import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentType, () {
    group('serialization', () {
      group('fromJson', () {
        test('simply string value is accepted as single entry', () {
          // Given
          const json = '7808d2ba-d511-40af-84e8-c0d1625fdfdc';

          // When
          final documentType = DocumentType.fromJson(json);

          // Then
          expect(documentType.value, allOf(hasLength(1), contains(json)));
        });

        test('joined string value is accepted as list of values', () {
          // Given
          const value1 = '0ce8ab38-9258-4fbc-a62e-7faa6e58318f';
          const value2 = '7808d2ba-d511-40af-84e8-c0d1625fdfdc';
          const json = '$value1,$value2';

          // When
          final documentType = DocumentType.fromJson(json);

          // Then
          expect(documentType.value, allOf(hasLength(2), containsAllInOrder([value1, value2])));
        });

        test('dynamic list of strings is accepted and decoded', () {
          // Given
          const value1 = '0ce8ab38-9258-4fbc-a62e-7faa6e58318f';
          const value2 = '7808d2ba-d511-40af-84e8-c0d1625fdfdc';
          const json = <dynamic>[value1, value2];

          // When
          final documentType = DocumentType.fromJson(json);

          // Then
          expect(documentType.value, allOf(hasLength(2), containsAllInOrder([value1, value2])));
        });

        test('int value throws error', () {
          // Given
          const json = 1;

          // When
          DocumentType parse() => DocumentType.fromJson(json);

          // Then
          expect(parse, throwsA(isA<ArgumentError>()));
        });
      });

      group('toJson', () {
        test('resolves as joined string', () {
          // Given
          const documentType = DocumentType.proposalDocument;

          final expectedJson = documentType.value.join(',');

          // When
          final json = documentType.toJson();

          // Then
          expect(json, expectedJson);
        });
      });

      test('encoding and decoding back results in same object', () {
        // Given
        const documentType = DocumentType.proposalDocument;
        const expectedDocumentType = DocumentType.proposalDocument;

        // When
        final json = documentType.toJson();
        final decoded = DocumentType.fromJson(json);

        // Then
        expect(decoded, expectedDocumentType);
      });
    });

    group('template', () {
      test('proposalDocument returns proposalTemplate', () {
        // Given
        const documentType = DocumentType.proposalDocument;
        const expectedTemplate = DocumentType.proposalTemplate;

        // When
        final template = documentType.template;

        // Then
        expect(template, expectedTemplate);
      });
    });

    group('priority', () {
      test('of proposalTemplate is higher then proposalDocument', () {
        // Given
        const document = DocumentType.proposalDocument;
        const template = DocumentType.proposalTemplate;

        // When
        final documentPriority = document.priority;
        final templatePriority = template.priority;

        // Then
        expect(templatePriority > documentPriority, isTrue);
      });
    });
  });
}
