import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SingleDropdownSelectionWidget extends StatefulWidget {
  final String value;
  final List<String> items;
  final DropDownSingleSelectDefinition definition;
  final DocumentNodeId nodeId;
  final String title;
  final bool isEditMode;
  final bool isRequired;
  final ValueChanged<DocumentChange> onChanged;

  const SingleDropdownSelectionWidget({
    super.key,
    required this.value,
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
  late TextEditingController _textEditingController;

  String? value;

  List<DropdownMenuEntry<String>> get _mapItems {
    final items = widget.items;
    return items.map((e) => DropdownMenuEntry(value: e, label: e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.value;

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
      _textEditingController.text = value;
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
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SingleSelectDropdown(
          textEditingController: _textEditingController,
          items: _dropdownMenuEntries,
          enabled: widget.isEditMode,
          onSelected: (val) {
            widget.onChanged(DocumentChange(nodeId: widget.nodeId, value: val));
          },
          initialValue: widget.value,
        ),
      ],
    );
  }
}
