import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SingleDropdownSelectionWidget extends StatefulWidget {
  final String? value;
  final String defaultValue;
  final List<String> items;
  final DropDownSingleSelectDefinition definition;
  final DocumentNodeId nodeId;
  final String title;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;
  const SingleDropdownSelectionWidget({
    super.key,
    this.value,
    required this.defaultValue,
    required this.items,
    required this.definition,
    required this.nodeId,
    required this.title,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<SingleDropdownSelectionWidget> createState() =>
      _SingleDropdownSelectionWidgetState();
}

class _SingleDropdownSelectionWidgetState
    extends State<SingleDropdownSelectionWidget> {
  late List<DropdownMenuEntry<String>> _dropdownMenuEntries;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dropdownMenuEntries =
        widget.items.map((e) => DropdownMenuEntry(value: e, label: e)).toList();
  }

  @override
  void didUpdateWidget(covariant SingleDropdownSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {}
    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      print('Cancelled');
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          DropdownMenu(
            controller: _textEditingController,
            width: double.infinity,
            enabled: widget.isEditMode,
            hintText: widget.defaultValue,
            dropdownMenuEntries: _dropdownMenuEntries,
            onSelected: (val) {
              widget.onChanged(
                DocumentChange(nodeId: widget.nodeId, value: val),
              );
            },
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colors.textDisabled,
                  ),
              fillColor:
                  Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
              filled: true,
              enabledBorder: _border,
              disabledBorder: _border,
              focusedBorder: _border,
            ),
            trailingIcon: widget.isEditMode
                ? VoicesAssets.icons.chevronDown.buildIcon()
                : const Offstage(),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colors.outlineBorderVariant!,
        ),
      );
}
