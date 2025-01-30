import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ListLengthPickerWidget extends StatelessWidget {
  final DocumentListProperty list;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const ListLengthPickerWidget({
    super.key,
    required this.list,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final range = list.schema.itemsRange;
    final minCount = range?.min ?? 0;
    final maxCount = range?.max ?? 100;
    final currentCount = list.properties.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          list.schema.formattedDescriptionOrTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SingleSelectDropdown(
          items: [
            for (int i = minCount; i <= maxCount; i++)
              DropdownMenuEntry(
                value: i,
                label: _formatAsPlural(list.schema.itemsSchema.title, i),
              ),
          ],
          enabled: isEditMode,
          onChanged: _onChanged,
          initialValue: currentCount,
          hintText: list.schema.placeholder,
        ),
      ],
    );
  }

  void _onChanged(int? newCount) {
    final currentCount = list.properties.length;
    if (newCount == null || newCount == currentCount) {
      return;
    }

    if (newCount > currentCount) {
      final remainingCount = newCount - currentCount;
      final change = DocumentAddListItemChange(nodeId: list.nodeId);
      final changes = List.filled(remainingCount, change);
      onChanged(changes);
    } else {
      final remainingCount = currentCount - newCount;
      final changes = list.properties.reversed
          .take(remainingCount)
          .map((e) => DocumentRemoveListItemChange(nodeId: e.nodeId))
          .toList();
      onChanged(changes);
    }
  }

  // TODO(dtscalac): temporary solution to format dynamic strings as plural,
  // after F14 the document schema must be altered to support
  // other languages than English.
  //
  // The current workaround won't work for exceptions like "mouse" -> "mice",
  // this was accepted for the time being.
  String _formatAsPlural(String word, int count) {
    if (word.isEmpty) {
      // cannot make plural, lets just use the number
      return count.toString();
    }

    return switch (count) {
      1 => '$count $word',
      _ => '$count ${word}s',
    };
  }
}
