import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:test/test.dart';

import '../../helpers/read_json.dart';

void main() {
  group(BaseDocumentDefinition, () {
    const schemaPath =
        'test/assets/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json';

    late Map<String, dynamic> schemaJson;

    setUpAll(() {
      schemaJson = json.decode(readJson(schemaPath)) as Map<String, dynamic>;
    });
    test(
      // ignore: lines_longer_than_80_chars
      'Check if all definition are in definition list inside DefinitionDto model',
      () async {
        final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
        final definitions = schemaDto.definitions.models;

        for (final value
            in BaseDocumentDefinition.refPathToDefinitionType.values) {
          final occurrences = definitions
              .where((element) => element.runtimeType == value)
              .length;
          expect(
            occurrences,
            equals(1),
            reason: 'Value $value appears $occurrences times in the list',
          );
        }
      },
    );

    test('Check if document definition media type is parse correctly', () {
      final schemaDto = DocumentSchemaDto.fromJson(schemaJson);
      final definitions = schemaDto.definitions.models;

      final singleLineTextEntry =
          definitions.getDefinition('#/definitions/singleLineTextEntry')
              as SingleLineTextEntryDefinition;

      expect(
        singleLineTextEntry.contentMediaType,
        DocumentDefinitionsContentMediaType.textPlain,
      );
    });
  });
}
