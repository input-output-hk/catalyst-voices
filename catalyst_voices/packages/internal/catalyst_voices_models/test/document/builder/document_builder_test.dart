import 'package:catalyst_voices_models/src/document/builder/document_builder.dart';
import 'package:catalyst_voices_models/src/document/builder/document_change.dart';
import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/schema/document_schema.dart';
import 'package:catalyst_voices_models/src/document/schema/property/document_property_schema.dart';
import 'package:catalyst_voices_models/src/document/validation/document_validation_result.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentBuilder, () {
    final titleNodeId = DocumentNodeId.root.child('title');
    final objectNodeId = DocumentNodeId.root.child('object');
    final budgetNodeId = objectNodeId.child('budget');
    final listNodeId = DocumentNodeId.root.child('list');

    final titleSchema =
        DocumentGenericStringSchema.optional(nodeId: titleNodeId);
    final budgetSchema =
        DocumentGenericIntegerSchema.optional(nodeId: budgetNodeId);

    final objectSchema = DocumentGenericObjectSchema.optional(
      nodeId: objectNodeId,
      properties: [budgetSchema],
    );

    final listSchema = DocumentGenericListSchema.optional(nodeId: listNodeId);

    final schema = DocumentSchema.optional(
      properties: [
        titleSchema,
        objectSchema,
        listSchema,
      ],
      order: [objectNodeId, titleNodeId, listNodeId],
    );

    test('should create an empty builder from schema', () {
      final document = DocumentBuilder.fromSchema(schema: schema).build();

      expect(document.schema, schema);
      expect(
        document.properties,
        equals(
          [
            DocumentObjectProperty(
              schema: objectSchema,
              validationResult: const SuccessfulDocumentValidation(),
              properties: [
                DocumentValueProperty<int>(
                  schema: budgetSchema,
                  value: null,
                  validationResult: const SuccessfulDocumentValidation(),
                ),
              ],
            ),
            DocumentValueProperty<String>(
              schema: titleSchema,
              value: null,
              validationResult: const SuccessfulDocumentValidation(),
            ),
            DocumentListProperty(
              schema: listSchema,
              properties: const [],
              validationResult: const SuccessfulDocumentValidation(),
            ),
          ],
        ),
      );
    });

    test('should create a builder from an existing document', () {
      final document = Document(
        schema: schema,
        properties: [
          DocumentObjectProperty(
            schema: objectSchema,
            validationResult: const SuccessfulDocumentValidation(),
            properties: [
              DocumentValueProperty<int>(
                schema: budgetSchema,
                value: 123,
                validationResult: const SuccessfulDocumentValidation(),
              ),
            ],
          ),
          DocumentListProperty(
            schema: listSchema,
            properties: const [],
            validationResult: const SuccessfulDocumentValidation(),
          ),
          DocumentValueProperty<String>(
            schema: titleSchema,
            value: 'test-string',
            validationResult: const SuccessfulDocumentValidation(),
          ),
        ],
      );

      final builder = DocumentBuilder.fromDocument(document);

      final builtDocument = builder.build();
      final sortedProperties = List.of(document.properties)
        ..sortByOrder(document.schema.order);

      expect(builtDocument.schema, document.schema);
      expect(builtDocument.properties, sortedProperties);
    });

    test('should add a single change to the builder', () {
      final builder = DocumentBuilder.fromSchema(schema: schema);

      final change = DocumentValueChange(
        nodeId: titleNodeId,
        value: 'new-value',
      );

      builder.addChange(change);
      final document = builder.build();
      final property =
          document.getProperty(titleNodeId)! as DocumentValueProperty;

      expect(property.value, equals('new-value'));
    });

    test('should add multiple changes to the builder', () {
      final builder = DocumentBuilder.fromSchema(schema: schema);

      final changes = [
        DocumentValueChange(
          nodeId: titleNodeId,
          value: 'value1',
        ),
        DocumentValueChange(
          nodeId: titleNodeId,
          value: 'value2',
        ),
      ];

      builder.addChanges(changes);
      final document = builder.build();
      final property =
          document.getProperty(titleNodeId)! as DocumentValueProperty;

      expect(property.value, equals('value2'));
    });

    test('should add and remove list items', () {
      final builder = DocumentBuilder.fromSchema(schema: schema);

      final addItemChange =
          DocumentAddListItemChange(nodeId: listSchema.nodeId);

      // add the first item
      builder.addChange(addItemChange);

      // assert first item was added
      final document1 = builder.build();
      final listProperty1 =
          document1.getProperty(listSchema.nodeId)! as DocumentListProperty;
      expect(listProperty1.properties, hasLength(1));

      // add the second item
      builder.addChange(addItemChange);

      // assert second item was added
      final document2 = builder.build();
      final listProperty2 =
          document2.getProperty(listSchema.nodeId)! as DocumentListProperty;
      expect(listProperty2.properties, hasLength(2));

      final removeItemChange = DocumentRemoveListItemChange(
        nodeId: listProperty2.properties.last.nodeId,
      );

      // remove second item
      builder.addChange(removeItemChange);

      // assert there is only one item remaining
      final document3 = builder.build();
      final listProperty3 =
          document3.getProperty(listSchema.nodeId)! as DocumentListProperty;
      expect(listProperty3.properties, hasLength(1));
    });
  });
}
