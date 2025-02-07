import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/document_builder/document_error_text.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
  @override
  Widget build(BuildContext context) {
    return _TagWidget(
      value: widget.schema.groupedTagsSelection(widget.property),
      groupedTags: widget.schema.groupedTags(),
      hintText: widget.schema.placeholder,
      isRequired: widget.schema.isRequired,
      onChanged: _onChanged,
      validator: _validator,
      enabled: widget.isEditMode,
    );
  }

  void _onChanged(GroupedTagsSelection? value) {
    final changes = widget.schema.buildDocumentChanges(value);
    widget.onChanged(changes);
  }

  String? _validator(GroupedTagsSelection? value) {
    final schema = widget.schema;
    final result = schema.validateGroupedTagsSelection(value);

    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}

class _TagWidget extends VoicesFormField<GroupedTagsSelection> {
  _TagWidget({
    required super.value,
    super.onChanged,
    super.enabled,
    super.validator,
    required List<GroupedTags> groupedTags,
    required String? hintText,
    required bool isRequired,
  }) : super(
          builder: (field) {
            final selection = field.value ?? const GroupedTagsSelection();

            void onSelectionChanged(GroupedTagsSelection? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            void onGroupChanged(GroupedTags? groupedTags) {
              final groupChanged = selection.group != groupedTags?.group;

              final newSelection = selection.copyWith(
                group: Optional(groupedTags?.group),
                tag: groupChanged ? const Optional<String>.empty() : null,
              );

              onSelectionChanged(newSelection);
            }

            if (enabled) {
              return _TagSelector(
                groupedTags: groupedTags,
                selection: selection,
                onGroupChanged: onGroupChanged,
                onSelectionChanged: onSelectionChanged,
                hintText: hintText,
                errorText: field.errorText,
                isRequired: isRequired,
              );
            } else {
              return _GroupedTagChip(selection);
            }
          },
        );
}

class _TagSelector extends StatelessWidget {
  final List<GroupedTags> groupedTags;
  final GroupedTagsSelection selection;
  final ValueChanged<GroupedTags?> onGroupChanged;
  final ValueChanged<GroupedTagsSelection> onSelectionChanged;
  final String? hintText;
  final String? errorText;
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
    required this.errorText,
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
        if (errorText != null) ...[
          const SizedBox(height: 12),
          DocumentErrorText(text: errorText),
        ],
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
