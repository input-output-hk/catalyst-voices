import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
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

      final group = conditions
          .firstWhereOrNull((e) => e.schema is DocumentTagGroupSchema);
      final selection = conditions
          .firstWhereOrNull((e) => e.schema is DocumentTagSelectionSchema);

      if (group == null) {
        logger?.warning('Group[$group] definition is not group');
        return false;
      }

      if (group.constValue is! String) {
        logger?.warning('Group[$group] does not have String value');
        return false;
      }

      if (selection == null) {
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
        final group = e.conditions[0].constValue! as String;
        final values = e.conditions[1].enumValues!.cast<String>();

        return GroupedTags(
          group: group,
          tags: values,
        );
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
