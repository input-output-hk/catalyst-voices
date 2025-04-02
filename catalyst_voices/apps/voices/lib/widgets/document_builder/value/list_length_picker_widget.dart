import 'package:catalyst_voices/widgets/document_builder/common/document_property_builder_title.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
    final title = list.schema.title;
    final isRequired = list.schema.isRequired;
    final description = list.schema.description ?? MarkdownData.empty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title.isNotEmpty) ...[
          DocumentPropertyBuilderTitle(
            title: title,
            isRequired: isRequired,
          ),
          const SizedBox(height: 8),
        ],
        if (description.data.isNotEmpty && description.data != title) ...[
          MarkdownText(description),
          const SizedBox(height: 22),
        ],
        SingleSelectDropdown(
          items: [
            for (int i = minCount; i <= maxCount; i++)
              DropdownMenuEntry(
                value: i,
                label: list.schema.itemsSchema.title.formatAsPlural(i),
              ),
          ],
          enabled: isEditMode,
          onChanged: _onChanged,
          value: currentCount,
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
}
