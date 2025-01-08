import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
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
  final bool isRequired;
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
    required this.isRequired,
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
  String? value;

  @override
  void initState() {
    super.initState();
    _dropdownMenuEntries = widget.items
        .map(
          (e) => DropdownMenuEntry(
            value: e,
            label: e,
          ),
        )
        .toList();
  }

  @override
  void didUpdateWidget(covariant SingleDropdownSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      if (widget.value == null) {
        _textEditingController.clear();
      } else {
        _textEditingController.value =
            TextEditingValue(text: widget.value ?? widget.defaultValue);
      }
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
          SingleSelectDropdown(
            textEditingController: _textEditingController,
            dropdownMenuEntries: _dropdownMenuEntries,
            isEditMode: widget.isEditMode,
            onSelected: (val) {
              widget
                  .onChanged(DocumentChange(nodeId: widget.nodeId, value: val));
            },
            hintText: widget.defaultValue,
          ),
        ],
      ),
    );
  }
}
