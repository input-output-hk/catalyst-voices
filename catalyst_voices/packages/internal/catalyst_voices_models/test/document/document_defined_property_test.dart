import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentDefinedProperty, () {
    group('factory', () {
      test('SingleGroupedTagSelectorDefinition builds selector', () {
        // Given
        const property = DocumentSchemaProperty.optional(
          definition: SingleGroupedTagSelectorDefinition.dummy(),
          nodeId: DocumentNodeId.root,
          id: 'grouped_tag',
          oneOf: [
            DocumentSchemaLogicalGroup(
              conditions: [
                DocumentSchemaLogicalCondition(
                  definition: TagGroupDefinition.dummy(),
                  id: 'group',
                  value: 'Education',
                  enumValues: null,
                ),
                DocumentSchemaLogicalCondition(
                  definition: TagSelectionDefinition.dummy(),
                  id: 'tag',
                  value: null,
                  enumValues: [
                    'Education',
                    'Learn to Earn',
                    'Training',
                    'Translation',
                  ],
                ),
              ],
            ),
          ],
          isRequired: false,
        );

        const expectedProperty = SingleGroupedTagSelector(
          groups: {
            'Education': [
              'Education',
              'Learn to Earn',
              'Training',
              'Translation',
            ],
          },
          isRequired: false,
        );

        // When

        final definedProperty = DocumentDefinedProperty.from(property);

        // Then
        expect(definedProperty, expectedProperty);
      });
    });

    group(SingleGroupedTagSelector, () {
      const group = DocumentSchemaLogicalCondition(
        definition: TagGroupDefinition.dummy(),
        id: 'group',
        value: 'Governance',
        enumValues: null,
      );
      const groupSelector = DocumentSchemaLogicalCondition(
        definition: TagSelectionDefinition.dummy(),
        id: 'tag',
        value: null,
        enumValues: [
          'Governance',
          'DAO',
        ],
      );

      test('correct oneOf produces valid selector', () {
        // Given
        const oneOf = [
          DocumentSchemaLogicalGroup(
            conditions: [
              group,
              groupSelector,
            ],
          ),
        ];

        const expectedSelector = SingleGroupedTagSelector(
          groups: {
            'Governance': ['Governance', 'DAO'],
          },
          isRequired: false,
        );

        // When
        final selector = SingleGroupedTagSelector.from(
          oneOf: oneOf,
          isRequired: false,
        );

        // Then
        expect(selector, expectedSelector);
      });

      test('when group is missing selector is not created', () {
        // Given
        const oneOf = [
          DocumentSchemaLogicalGroup(
            conditions: [
              groupSelector,
            ],
          ),
        ];

        const expectedSelector = SingleGroupedTagSelector(
          groups: {},
          isRequired: false,
        );

        // When
        final selector = SingleGroupedTagSelector.from(
          oneOf: oneOf,
          isRequired: false,
        );

        // Then
        expect(selector, expectedSelector);
      });

      test('when group selector is missing selector is not created', () {
        // Given
        const oneOf = [
          DocumentSchemaLogicalGroup(
            conditions: [
              group,
            ],
          ),
        ];

        const expectedSelector = SingleGroupedTagSelector(
          groups: {},
          isRequired: false,
        );

        // When
        final selector = SingleGroupedTagSelector.from(
          oneOf: oneOf,
          isRequired: false,
        );

        // Then
        expect(selector, expectedSelector);
      });

      test('when group value is missing selector is not created', () {
        // Given
        const oneOf = [
          DocumentSchemaLogicalGroup(
            conditions: [
              DocumentSchemaLogicalCondition(
                definition: TagGroupDefinition.dummy(),
                id: 'group',
                value: null,
                enumValues: null,
              ),
              groupSelector,
            ],
          ),
        ];

        const expectedSelector = SingleGroupedTagSelector(
          groups: {},
          isRequired: false,
        );

        // When
        final selector = SingleGroupedTagSelector.from(
          oneOf: oneOf,
          isRequired: false,
        );

        // Then
        expect(selector, expectedSelector);
      });

      test('when group value is invalid selector is not created', () {
        // Given
        const oneOf = [
          DocumentSchemaLogicalGroup(
            conditions: [
              DocumentSchemaLogicalCondition(
                definition: TagGroupDefinition.dummy(),
                id: 'group',
                value: 1,
                enumValues: null,
              ),
              groupSelector,
            ],
          ),
        ];

        const expectedSelector = SingleGroupedTagSelector(
          groups: {},
          isRequired: false,
        );

        // When
        final selector = SingleGroupedTagSelector.from(
          oneOf: oneOf,
          isRequired: false,
        );

        // Then
        expect(selector, expectedSelector);
      });

      test('when group selector enum is missing selector is not created', () {
        // Given
        const oneOf = [
          DocumentSchemaLogicalGroup(
            conditions: [
              group,
              DocumentSchemaLogicalCondition(
                definition: TagSelectionDefinition.dummy(),
                id: 'tag',
                value: null,
                enumValues: null,
              ),
            ],
          ),
        ];

        const expectedSelector = SingleGroupedTagSelector(
          groups: {},
          isRequired: false,
        );

        // When
        final selector = SingleGroupedTagSelector.from(
          oneOf: oneOf,
          isRequired: false,
        );

        // Then
        expect(selector, expectedSelector);
      });
    });
  });
}
