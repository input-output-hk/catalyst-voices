import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SingleGroupedTagSelectorWidget extends StatefulWidget {
  final DocumentNodeId id;
  final GroupedTagsSelection selection;
  final List<GroupedTags> groupedTags;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;
  final bool isRequired;

  const SingleGroupedTagSelectorWidget({
    super.key,
    required this.id,
    this.selection = const GroupedTagsSelection(),
    required this.groupedTags,
    required this.isEditMode,
    required this.onChanged,
    required this.isRequired,
  });

  @override
  State<SingleGroupedTagSelectorWidget> createState() {
    return _SingleGroupedTagSelectorWidgetState();
  }
}

class _SingleGroupedTagSelectorWidgetState
    extends State<SingleGroupedTagSelectorWidget> {
  GroupedTagsSelection _selection = const GroupedTagsSelection();

  @override
  void initState() {
    super.initState();

    _selection = widget.selection;
  }

  @override
  void didUpdateWidget(covariant SingleGroupedTagSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selection != oldWidget.selection) {
      _selection = widget.selection;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditMode) {
      return _TagSelector(
        groupedTags: widget.groupedTags,
        selection: _selection,
        onGroupChanged: _handleGroupedTagsSelection,
        onSelectionChanged: _handleTagSelection,
        isRequired: widget.isRequired,
      );
    } else {
      return _TagChip(_selection);
    }
  }

  void _handleGroupedTagsSelection(GroupedTags? groupedTags) {
    setState(() {
      final groupChanged = _selection.group != groupedTags?.group;

      _selection = _selection.copyWith(
        group: Optional(groupedTags?.group),
        tag: groupChanged ? const Optional<String>.empty() : null,
      );
    });
  }

  void _handleTagSelection(GroupedTagsSelection value) {
    setState(() {
      _selection = value;

      final change = DocumentChange(nodeId: widget.id, value: value);
      widget.onChanged(change);
    });
  }
}

class _TagSelector extends StatelessWidget {
  final List<GroupedTags> groupedTags;
  final GroupedTagsSelection selection;
  final ValueChanged<GroupedTags?> onGroupChanged;
  final ValueChanged<GroupedTagsSelection> onSelectionChanged;
  final bool isRequired;

  GroupedTags? get _selectedGroupedTags {
    final selected = groupedTags.firstWhereOrNull(selection.selects);

    return selected ?? groupedTags.firstOrNull;
  }

  const _TagSelector({
    required this.groupedTags,
    required this.selection,
    required this.onGroupChanged,
    required this.onSelectionChanged,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    final selectedGroup = _selectedGroupedTags;

    final tags = selectedGroup?.tags ?? const [];
    final selectedTag = tags.contains(selection.tag) ? selection.tag : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TagSelectorLabel(
          context.l10n.singleGroupedTagSelectorTitle,
          starred: isRequired,
        ),
        const SizedBox(height: 4),
        _TagGroupsDropdown(
          groupedTags: groupedTags,
          onChanged: onGroupChanged,
          value: selectedGroup,
        ),
        const SizedBox(height: 8.5),
        _TagSelectorLabel(
          context.l10n.singleGroupedTagSelectorRelevantTag,
          starred: isRequired,
        ),
        const SizedBox(height: 12),
        _TagChipGroup(
          tags: tags,
          selected: selectedTag,
          onChanged: (tag) {
            final group = selectedGroup!.group;

            final selection = GroupedTagsSelection(group: group, tag: tag);

            onSelectionChanged(selection);
          },
        ),
      ],
    );
  }
}

class _TagSelectorLabel extends StatelessWidget {
  final String data;
  final bool starred;

  const _TagSelectorLabel(
    this.data, {
    required this.starred,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final textTheme = theme.textTheme;

    return Text(
      data.starred(isEnabled: starred),
      style: textTheme.titleSmall?.copyWith(color: colors.textOnPrimaryLevel0),
    );
  }
}

class _TagGroupsDropdown extends StatelessWidget {
  final List<GroupedTags> groupedTags;
  final ValueChanged<GroupedTags?> onChanged;
  final GroupedTags? value;

  const _TagGroupsDropdown({
    required this.groupedTags,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDropdown<GroupedTags>(
      items: groupedTags
          .map((e) => DropdownMenuEntry(value: e, label: e.group))
          .toList(),
      onChanged: onChanged,
      value: value,
    );
  }
}

class _TagChipGroup extends StatelessWidget {
  final List<String> tags;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _TagChipGroup({
    required this.tags,
    this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = this.selected;

    return VoicesSegmentedButton<String>(
      segments: tags
          .map((tag) => ButtonSegment(value: tag, label: Text(tag)))
          .toList(),
      selected: {
        if (selected != null) selected,
      },
      onChanged: (value) {
        onChanged(value.firstOrNull);
      },
      multiSelectionEnabled: false,
      emptySelectionAllowed: true,
    );
  }
}

class _TagChip extends StatelessWidget {
  final GroupedTagsSelection selection;

  const _TagChip(this.selection);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final textTheme = theme.textTheme;

    final isValid = selection.isValid;

    final backgroundColor =
        isValid ? colors.onPrimaryContainer : colors.onSurfaceNeutralOpaqueLv2;
    final foregroundColor =
        isValid ? colors.textOnPrimary : colors.textDisabled;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(
        isValid ? '$selection' : context.l10n.noTagSelected,
        style: textTheme.labelLarge?.copyWith(color: foregroundColor),
      ),
    );
  }
}
