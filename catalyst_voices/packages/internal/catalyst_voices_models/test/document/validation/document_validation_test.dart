import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group('$DocumentValidator', () {
    group('$SingleLineHttpsURLEntryDefinition validation', () {
      late DocumentProperty<String> property;

      setUp(() {
        property = const DocumentProperty<String>(
          schema: DocumentSchemaProperty(
            definition: SingleLineHttpsURLEntryDefinition(
              type: DocumentDefinitionsObjectType.string,
              note: '',
              format: DocumentDefinitionsFormat.uri,
              pattern: '^https://',
            ),
            nodeId: DocumentNodeId.root,
            id: '',
            title: '',
            description: '',
            defaultValue: null,
            guidance: '',
            enumValues: null,
            numRange: null,
            strLengthRange: null,
            itemsRange: null,
            oneOf: null,
            isRequired: true,
          ),
          value: null,
          validationResult: SuccessfulDocumentValidation(),
        );
      });

      test('value cannot be null when required', () {
        final result = property.schema.validatePropertyValue(null);

        expect(result, isA<MissingRequiredDocumentValue>());
      });

      test('value is valid when matches pattern', () {
        final result =
            property.schema.validatePropertyValue('https://www.catalyst.org/');

        expect(result, isA<SuccessfulDocumentValidation>());
      });
    });
  });
}
