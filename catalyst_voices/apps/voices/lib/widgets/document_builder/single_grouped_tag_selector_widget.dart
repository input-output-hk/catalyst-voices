import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
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
  late GroupedTagsSelection _selection;

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
      return _GroupedTagChip(_selection);
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
          selectedTag: selectedTag,
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
    return VoicesDropdownFormField<GroupedTags>(
      items: groupedTags
          .map((e) => DropdownMenuItem(value: e, child: Text(e.group)))
          .toList(),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _TagChipGroup extends StatelessWidget {
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String?> onChanged;

  const _TagChipGroup({
    required this.tags,
    this.selectedTag,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTag = this.selectedTag;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tags.map((tag) {
        final isSelected = tag == selectedTag;
        return _TagChip(
          key: ObjectKey(tag),
          name: tag,
          isSelected: isSelected,
          isEnabled: true,
          onTap: () => isSelected ? onChanged(null) : onChanged(tag),
        );
      }).toList(),
    );
  }
}

class _GroupedTagChip extends StatelessWidget {
  final GroupedTagsSelection data;

  const _GroupedTagChip(
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    final isValid = data.isValid;

    return _TagChip(
      key: const ValueKey('SelectedGroupedTagChipKey'),
      name: isValid ? '$data' : context.l10n.noTagSelected,
      isSelected: isValid,
      isEnabled: isValid,
    );
  }
}

class _TagChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  Set<WidgetState> get states => {
        if (isSelected) WidgetState.selected,
        if (!isEnabled) WidgetState.disabled,
      };

  const _TagChip({
    super.key,
    required this.name,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    final backgroundColor = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return colors.onSurfaceNeutralOpaqueLv2;
      }

      if (states.contains(WidgetState.selected)) {
        return colors.onPrimaryContainer;
      }

      return null;
    });

    final foregroundColor = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return colors.textDisabled;
      }

      if (states.contains(WidgetState.selected)) {
        return colors.textOnPrimaryWhite;
      }

      return null;
    });

    return VoicesChip.rectangular(
      content: Text(
        name,
        style: TextStyle(color: foregroundColor.resolve(states)),
      ),
      trailing: onTap != null && isSelected
          ? Icon(
              Icons.clear,
              color: foregroundColor.resolve(states),
            )
          : null,
      backgroundColor: backgroundColor.resolve(states),
      onTap: onTap,
    );
  }
}
