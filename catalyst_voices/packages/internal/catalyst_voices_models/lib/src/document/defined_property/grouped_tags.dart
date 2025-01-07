import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class GroupedTagsSelection extends Equatable {
  final String? group;
  final String? tag;

  const GroupedTagsSelection({
    this.group,
    this.tag,
  });

  bool get isValid => group != null && tag != null;

  GroupedTagsSelection copyWith({
    Optional<String>? group,
    Optional<String>? tag,
  }) {
    return GroupedTagsSelection(
      group: group.dataOr(this.group),
      tag: tag.dataOr(this.tag),
    );
  }

  bool selects(GroupedTags groupedTag) {
    final group = this.group;
    final tag = this.tag;

    final groupMatches = group == groupedTag.group;
    final tagFoundOrNull = tag == null || groupedTag.tags.contains(tag);

    return groupMatches && tagFoundOrNull;
  }

  @override
  String toString() => '$group: $tag';

  @override
  List<Object?> get props => [
        group,
        tag,
      ];
}

final class GroupedTags extends Equatable {
  final String group;
  final List<String> tags;

  const GroupedTags({
    required this.group,
    required this.tags,
  });

  // Note. this method may be converted to factory function for
  // SingleGroupedTagSelector which extends DocumentProperty.
  // SingleGroupedTagSelector could easily implement validation.
  static List<GroupedTags> fromLogicalGroups(
    List<DocumentSchemaLogicalGroup> groups, {
    Logger? logger,
  }) {
    return groups.where((element) {
      final conditions = element.conditions;
      if (conditions.length != 2) {
        logger?.warning('$element has invalid conditions length (!=2)');
        return false;
      }

      final group = conditions[0];
      final selection = conditions[1];

      if (group.definition is! TagGroupDefinition) {
        logger?.warning('Group[$group] definition is not group');
        return false;
      }

      if (group.value is! String) {
        logger?.warning('Group[$group] does not have String value');
        return false;
      }

      if (selection.definition is! TagSelectionDefinition) {
        logger?.warning('Group[$selection] definition is not selection');
        return false;
      }

      if (selection.enumValues == null) {
        logger?.warning('Group[$selection] does not have enum values');
        return false;
      }

      return true;
    }).map(
      (e) {
        final group = e.conditions[0].value! as String;
        final values = e.conditions[1].enumValues!;

        return GroupedTags(group: group, tags: values);
      },
    ).toList();
  }

  @override
  String toString() => '$group: $tags';

  @override
  List<Object?> get props => [
        group,
        tags,
      ];
}
