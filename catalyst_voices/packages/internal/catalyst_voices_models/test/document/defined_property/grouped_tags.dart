import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(GroupedTags, () {
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

      const expected = [
        GroupedTags(group: 'Governance', tags: ['Governance', 'DAO']),
      ];

      // When
      final selector = GroupedTags.fromLogicalGroups(oneOf);

      // Then
      expect(selector, expected);
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

      const expected = <GroupedTags>[];

      // When
      final selector = GroupedTags.fromLogicalGroups(oneOf);

      // Then
      expect(selector, expected);
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

      const expected = <GroupedTags>[];

      // When
      final selector = GroupedTags.fromLogicalGroups(oneOf);

      // Then
      expect(selector, expected);
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

      const expected = <GroupedTags>[];

      // When
      final selector = GroupedTags.fromLogicalGroups(oneOf);

      // Then
      expect(selector, expected);
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

      const expected = <GroupedTags>[];

      // When
      final selector = GroupedTags.fromLogicalGroups(oneOf);

      // Then
      expect(selector, expected);
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

      const expected = <GroupedTags>[];

      // When
      final selector = GroupedTags.fromLogicalGroups(oneOf);

      // Then
      expect(selector, expected);
    });
  });
}
