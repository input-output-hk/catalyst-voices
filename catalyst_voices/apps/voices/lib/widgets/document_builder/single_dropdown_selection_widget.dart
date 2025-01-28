import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SingleDropdownSelectionWidget extends StatefulWidget {
  final String value;
  final List<String> items;
  final DocumentDropDownSingleSelectSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const SingleDropdownSelectionWidget({
    super.key,
    required this.value,
    required this.items,
    required this.schema,
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
  late TextEditingController _textEditingController;

  String? value;

  List<DropdownMenuEntry<String>> get _mapItems {
    final items = widget.items;
    return items.map((e) => DropdownMenuEntry(value: e, label: e)).toList();
  }

  @override
  void initState() {
    super.initState();
    final textValue = TextEditingValueExt.collapsedAtEndOf(widget.value);
    _textEditingController = TextEditingController.fromValue(textValue);
    _dropdownMenuEntries = _mapItems;
  }

  @override
  void didUpdateWidget(covariant SingleDropdownSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      _dropdownMenuEntries = _mapItems;
    }
    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      final value = widget.value;
      _textEditingController.textWithSelection = value;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.schema.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SingleSelectDropdown(
          textEditingController: _textEditingController,
          items: _dropdownMenuEntries,
          enabled: widget.isEditMode,
          onSelected: (val) {
            final change = DocumentValueChange(
              nodeId: widget.schema.nodeId,
              value: val,
            );
            widget.onChanged([change]);
          },
          initialValue: widget.value,
          hintText: widget.schema.placeholder,
        ),
      ],
    );
  }
}
