import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentObjectSchema, () {
    group(DocumentSingleGroupedTagSelectorSchema, () {
      final groupSchema = DocumentTagGroupSchema(
        nodeId: DocumentNodeId.root.child('group'),
        format: DocumentPropertyFormat.tagGroup,
        contentMediaType: DocumentContentMediaType.textPlain,
        title: 'title',
        description: MarkdownData.empty,
        placeholder: 'placeholder',
        guidance: const MarkdownData('guidance'),
        isSubsection: false,
        isRequired: true,
        defaultValue: null,
        constValue: 'Comedy',
        enumValues: null,
        strLengthRange: null,
        pattern: null,
      );

      final selectionSchema = DocumentTagSelectionSchema(
        nodeId: DocumentNodeId.root.child('tag'),
        format: DocumentPropertyFormat.tagSelection,
        contentMediaType: DocumentContentMediaType.textPlain,
        title: 'title',
        description: MarkdownData.empty,
        placeholder: 'placeholder',
        guidance: const MarkdownData('guidance'),
        isSubsection: false,
        isRequired: true,
        defaultValue: null,
        constValue: 'Movie',
        enumValues: null,
        strLengthRange: null,
        pattern: null,
      );

      final tagGroupSchema = DocumentSingleGroupedTagSelectorSchema(
        nodeId: DocumentNodeId.root,
        format: DocumentPropertyFormat.singleGroupedTagSelector,
        title: 'title',
        description: MarkdownData.empty,
        placeholder: 'placeholder',
        guidance: const MarkdownData('guidance'),
        isSubsection: false,
        isRequired: false,
        properties: [
          groupSchema,
          selectionSchema,
        ],
        oneOf: [
          DocumentSchemaLogicalGroup(
            conditions: [
              DocumentSchemaLogicalCondition(
                schema: groupSchema,
                constValue: 'Movie',
                enumValues: null,
              ),
              DocumentSchemaLogicalCondition(
                schema: selectionSchema,
                constValue: null,
                enumValues: const ['Comedy', 'Sci-Fi', 'Thriller'],
              ),
            ],
          ),
        ],
        order: const [],
      );

      test('validate empty selection returns $MissingRequiredDocumentValue',
          () {
        final result = tagGroupSchema.validate([
          DocumentValueProperty<String>(
            schema: groupSchema,
            value: null,
            validationResult: const SuccessfulDocumentValidation(),
          ),
          DocumentValueProperty<String>(
            schema: selectionSchema,
            value: null,
            validationResult: const SuccessfulDocumentValidation(),
          ),
        ]);

        expect(result, isA<MissingRequiredDocumentValue>());
      });

      test('validate invalid group returns $DocumentEnumValueMismatch', () {
        final result = tagGroupSchema.validate([
          DocumentValueProperty<String>(
            schema: groupSchema,
            value: 'Invalid group',
            validationResult: const SuccessfulDocumentValidation(),
          ),
          DocumentValueProperty<String>(
            schema: selectionSchema,
            value: 'Comedy',
            validationResult: const SuccessfulDocumentValidation(),
          ),
        ]);

        expect(result, isA<DocumentEnumValueMismatch>());
      });

      test('validate invalid selection returns $DocumentEnumValueMismatch', () {
        final result = tagGroupSchema.validate([
          DocumentValueProperty<String>(
            schema: groupSchema,
            value: 'Movie',
            validationResult: const SuccessfulDocumentValidation(),
          ),
          DocumentValueProperty<String>(
            schema: selectionSchema,
            value: 'Invalid selection',
            validationResult: const SuccessfulDocumentValidation(),
          ),
        ]);

        expect(result, isA<DocumentEnumValueMismatch>());
      });

      test(
          'validate correct group and selection '
          ' returns $DocumentEnumValueMismatch', () {
        final result = tagGroupSchema.validate([
          DocumentValueProperty<String>(
            schema: groupSchema,
            value: 'Movie',
            validationResult: const SuccessfulDocumentValidation(),
          ),
          DocumentValueProperty<String>(
            schema: selectionSchema,
            value: 'Comedy',
            validationResult: const SuccessfulDocumentValidation(),
          ),
        ]);

        expect(result, isA<SuccessfulDocumentValidation>());
      });
    });
  });
}
