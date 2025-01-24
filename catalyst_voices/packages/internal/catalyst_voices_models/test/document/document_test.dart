import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(Document, () {
    group('isValid()', () {
      test('$DocumentListProperty is valid when all children are valid', () {
        final nodeId = DocumentNodeId.root.child('object');
        final childSchema = DocumentGenericStringSchema.optional(
          nodeId: nodeId.child('1'),
          isRequired: true,
        );

        final listSchema = DocumentGenericListSchema.optional(
          nodeId: nodeId,
          itemsSchema: childSchema,
        );

        final childProperty = DocumentValueProperty<String>(
          schema: childSchema,
          value: 'value1',
          validationResult: childSchema.validate('value1'),
        );

        final properties = [childProperty];

        final listProperty = DocumentListProperty(
          schema: listSchema,
          properties: properties,
          validationResult: listSchema.validate(properties),
        );

        expect(listProperty.isValid, isTrue);
      });

      test('$DocumentListProperty is invalid when any child is invalid', () {
        final nodeId = DocumentNodeId.root.child('object');
        final childSchema1 = DocumentGenericStringSchema.optional(
          nodeId: nodeId.child('1'),
          isRequired: true,
        );

        final childSchema2 = DocumentGenericIntegerSchema.optional(
          nodeId: nodeId.child('2'),
          isRequired: true,
        );

        final listSchema = DocumentGenericListSchema.optional(
          nodeId: nodeId,
          itemsSchema: childSchema1,
        );

        final childProperty1 = DocumentValueProperty<String>(
          schema: childSchema1,
          value: 'value1',
          validationResult: childSchema1.validate('value1'),
        );
        final childProperty2 = DocumentValueProperty<int>(
          schema: childSchema2,
          value: null,
          validationResult: childSchema2.validate(null),
        );

        final properties = [childProperty1, childProperty2];

        final objectProperty = DocumentListProperty(
          schema: listSchema,
          properties: properties,
          validationResult: listSchema.validate(properties),
        );

        expect(objectProperty.isValid, isFalse);
      });
      test('$DocumentObjectProperty is valid when all children are valid', () {
        final nodeId = DocumentNodeId.root.child('object');
        final childSchema = DocumentGenericStringSchema.optional(
          nodeId: nodeId.child('1'),
          isRequired: true,
        );

        final objectSchema = DocumentGenericObjectSchema.optional(
          nodeId: nodeId,
          properties: [childSchema],
        );

        final childProperty = DocumentValueProperty<String>(
          schema: childSchema,
          value: 'value1',
          validationResult: childSchema.validate('value1'),
        );

        final properties = [childProperty];

        final objectProperty = DocumentObjectProperty(
          schema: objectSchema,
          properties: properties,
          validationResult: objectSchema.validate(properties),
        );

        expect(objectProperty.isValid, isTrue);
      });

      test('$DocumentObjectProperty is invalid when any child is invalid', () {
        final nodeId = DocumentNodeId.root.child('object');
        final childSchema1 = DocumentGenericStringSchema.optional(
          nodeId: nodeId.child('1'),
          isRequired: true,
        );

        final childSchema2 = DocumentGenericIntegerSchema.optional(
          nodeId: nodeId.child('2'),
          isRequired: true,
        );

        final objectSchema = DocumentGenericObjectSchema.optional(
          nodeId: nodeId,
          properties: [
            childSchema1,
            childSchema2,
          ],
        );

        final childProperty1 = DocumentValueProperty<String>(
          schema: childSchema1,
          value: 'value1',
          validationResult: childSchema1.validate('value1'),
        );
        final childProperty2 = DocumentValueProperty<int>(
          schema: childSchema2,
          value: null,
          validationResult: childSchema2.validate(null),
        );

        final properties = [childProperty1, childProperty2];

        final objectProperty = DocumentObjectProperty(
          schema: objectSchema,
          properties: properties,
          validationResult: objectSchema.validate(properties),
        );

        expect(objectProperty.isValid, isFalse);
      });

      test('$DocumentValueProperty is valid when validation passes', () {
        final nodeId = DocumentNodeId.root.child('title');
        final schema = DocumentGenericStringSchema.optional(
          nodeId: nodeId,
          isRequired: true,
        );

        const value = 'test';

        final property = DocumentValueProperty<String>(
          schema: schema,
          value: value,
          validationResult: schema.validate(value),
        );

        expect(property.isValid, isTrue);
      });

      test('$DocumentValueProperty is invalid when validation fails', () {
        final nodeId = DocumentNodeId.root.child('title');
        final schema = DocumentGenericStringSchema.optional(
          nodeId: nodeId,
          isRequired: true,
        );

        const String? value = null;

        final property = DocumentValueProperty<String>(
          schema: schema,
          value: value,
          validationResult: schema.validate(value),
        );

        expect(property.isValid, isFalse);
      });
    });

    group('getProperty()', () {
      final titleProperty = DocumentValueProperty(
        schema: DocumentGenericStringSchema.optional(
          nodeId: DocumentNodeId.root.child('setup').child('items').child('0'),
        ),
        value: 'Test title',
        validationResult: const SuccessfulDocumentValidation(),
      );

      final listProperty = DocumentListProperty(
        schema: DocumentGenericListSchema.optional(
          nodeId: DocumentNodeId.root.child('setup').child('items'),
        ),
        properties: [titleProperty],
        validationResult: const SuccessfulDocumentValidation(),
      );

      final objectProperty = DocumentObjectProperty(
        schema: DocumentGenericObjectSchema.optional(
          nodeId: DocumentNodeId.root.child('setup'),
        ),
        properties: [listProperty],
        validationResult: const SuccessfulDocumentValidation(),
      );

      final document = Document(
        schema: const DocumentSchema.optional(),
        properties: [
          objectProperty,
        ],
      );

      test('top level property is found', () {
        final nodeId = DocumentNodeId.root.child('setup');

        expect(
          document.getProperty(nodeId),
          isA<DocumentObjectProperty>(),
        );
      });

      test('property nested in object is found', () {
        final nodeId = DocumentNodeId.root.child('setup').child('items');
        expect(
          document.getProperty(nodeId),
          isA<DocumentListProperty>(),
        );
      });

      test('property nested in list is found', () {
        final nodeId =
            DocumentNodeId.root.child('setup').child('items').child('0');
        expect(
          document.getProperty(nodeId),
          isA<DocumentValueProperty>(),
        );
      });

      test('not existing top-level property is not found', () {
        final nodeId = DocumentNodeId.root.child('not-existing');

        expect(
          document.getProperty(nodeId),
          isNull,
        );
      });

      test('not existing object property is not found', () {
        final nodeId = DocumentNodeId.root.child('setup').child('not-existing');
        expect(
          document.getProperty(nodeId),
          isNull,
        );
      });

      test('not existing list property is not found', () {
        final nodeId =
            DocumentNodeId.root.child('setup').child('items').child('1');
        expect(
          document.getProperty(nodeId),
          isNull,
        );
      });
    });
  });
}
