part of '../document_defined_property.dart';

final class SingleGroupedTagSelector extends DocumentDefinedProperty {
  final Map<String, List<String>> groups;

  @visibleForTesting
  const SingleGroupedTagSelector({
    required this.groups,
    required super.isRequired,
  });

  factory SingleGroupedTagSelector.from({
    required List<DocumentSchemaLogicalGroup> oneOf,
    required bool isRequired,
  }) {
    final entries = oneOf.where((element) {
      final conditions = element.conditions;
      if (conditions.length != 2) {
        _logger.warning('$element has invalid conditions length (!=2)');
        return false;
      }

      final group = conditions[0];
      final selection = conditions[1];

      if (group.definition is! TagGroupDefinition) {
        _logger.warning('Group[$group] definition is not group');
        return false;
      }

      if (group.value is! String) {
        _logger.warning('Group[$group] does not have String value');
        return false;
      }

      if (selection.definition is! TagSelectionDefinition) {
        _logger.warning('Group[$selection] definition is not selection');
        return false;
      }

      if (selection.enumValues == null) {
        _logger.warning('Group[$selection] does not have enum values');
        return false;
      }

      return true;
    }).map(
      (e) {
        final group = e.conditions[0].value! as String;
        final values = e.conditions[1].enumValues!;

        return MapEntry(group, values);
      },
    );

    final groups = Map.fromEntries(entries);

    return SingleGroupedTagSelector(
      groups: groups,
      isRequired: isRequired,
    );
  }

  @override
  List<Object?> get props => [
        groups,
        ...super.props,
      ];
}
