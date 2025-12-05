import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';

const _dividerEmbed = BlockEmbed('divider', 'hr');

const _dividerStyle3 = '---';

final SpaceShortcutEvent formatDividerToDividerStyle = SpaceShortcutEvent(
  character: _dividerStyle3,
  handler: (node, controller) => _handleFormatBlockStyleBySpaceEvent(
    controller: controller,
    character: _dividerStyle3,
    embeddable: _dividerEmbed,
  ),
);

bool _handleFormatBlockStyleBySpaceEvent({
  required QuillController controller,
  required String character,
  required Embeddable embeddable,
}) {
  assert(
    character.trim().isNotEmpty && character != '\n',
    'Expected character that cannot be empty, a whitespace or a new line. Got $character',
  );

  _updateSelectionForKeyPhrase(character, controller, embeddable);
  return true;
}

void _updateSelectionForKeyPhrase(
  String phrase,
  QuillController controller,
  Embeddable embeddable,
) {
  controller.replaceText(
    controller.selection.baseOffset - phrase.length,
    phrase.length,
    embeddable,
    TextSelection.collapsed(offset: controller.selection.baseOffset - phrase.length + 1),
  );

  final index = controller.selection.baseOffset;
  controller.replaceText(
    index,
    0,
    '\n',
    TextSelection.collapsed(offset: index + 1),
  );
}
