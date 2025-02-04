import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SingleGroupedTagSelectorWidget extends StatefulWidget {
  final DocumentSingleGroupedTagSelectorSchema schema;
  final DocumentObjectProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const SingleGroupedTagSelectorWidget({
    super.key,
    required this.schema,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
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

    _selection = _getInitialSelection(widget);
  }

  @override
  void didUpdateWidget(covariant SingleGroupedTagSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldSelection = _getInitialSelection(oldWidget);
    final newSelection = _getInitialSelection(widget);

    if (newSelection != oldSelection) {
      _selection = newSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditMode) {
      return _TagSelector(
        groupedTags: widget.schema.groupedTags(),
        selection: _selection,
        onGroupChanged: _handleGroupedTagsSelection,
        onSelectionChanged: _handleTagSelection,
        hintText: widget.schema.placeholder,
        isRequired: widget.schema.isRequired,
      );
    } else {
      return _GroupedTagChip(_selection);
    }
  }

  GroupedTagsSelection _getInitialSelection(
    SingleGroupedTagSelectorWidget from,
  ) {
    return from.schema.groupedTagsSelection(from.property) ??
        const GroupedTagsSelection();
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

      final changes = widget.schema.buildDocumentChanges(value);
      widget.onChanged(changes);
    });
  }
}

class _TagSelector extends StatelessWidget {
  final List<GroupedTags> groupedTags;
  final GroupedTagsSelection selection;
  final ValueChanged<GroupedTags?> onGroupChanged;
  final ValueChanged<GroupedTagsSelection> onSelectionChanged;
  final String? hintText;
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
    required this.hintText,
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
          hintText: hintText,
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
  final String? hintText;

  const _TagGroupsDropdown({
    required this.groupedTags,
    required this.onChanged,
    required this.value,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleSelectDropdown<GroupedTags>(
      items: groupedTags
          .map((e) => DropdownMenuEntry(value: e, label: e.group))
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
