import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/text_field/voices_autocomplete.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

final class SeedPhraseFieldController extends ValueNotifier<List<String>> {
  SeedPhraseFieldController([super._value = const <String>[]]);
}

class SeedPhraseField extends StatefulWidget {
  final int wordsCount;
  final List<String> wordList;
  final SeedPhraseFieldController? controller;
  final ValueChanged<List<String>>? onChanged;

  const SeedPhraseField({
    super.key,
    this.wordsCount = 12,
    this.wordList = const [],
    this.controller,
    this.onChanged,
  });

  @override
  State<SeedPhraseField> createState() => _SeedPhraseFieldState();
}

class _SeedPhraseFieldState extends State<SeedPhraseField> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  SeedPhraseFieldController? _controller;

  SeedPhraseFieldController get _effectiveController {
    return widget.controller ?? (_controller ??= SeedPhraseFieldController());
  }

  bool get _isCompleted {
    return _effectiveController.value.length == widget.wordsCount;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();

    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.outlineBorder!,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder(
          valueListenable: _effectiveController,
          builder: (context, value, _) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...value.mapIndexed(
                  (index, element) {
                    final isLast = index == value.length - 1;

                    return _WordCell(
                      key: ValueKey('Word${index}CellKey'),
                      nr: index + 1,
                      data: element,
                      onDeleteTap: isLast ? () => _deleteAt(index) : null,
                    );
                  },
                ),
                Offstage(
                  offstage: _isCompleted,
                  child: _WordField(
                    words: widget.wordList,
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    onSelected: _appendWord,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _appendWord(String data) {
    final words = [
      ..._effectiveController.value,
      data,
    ];

    _textEditingController.clear();

    if (words.length != widget.wordsCount) {
      _focusNode.requestFocus();
    }

    _effectiveController.value = words;
    widget.onChanged?.call(words);
  }

  void _deleteAt(int index) {
    final words = [..._effectiveController.value]..removeAt(index);

    if (words.length == widget.wordsCount - 1) {
      _textEditingController.clear();
      _focusNode.requestFocus();
    }

    _effectiveController.value = words;
    widget.onChanged?.call(words);
  }
}

class _WordCell extends StatelessWidget {
  final int nr;
  final String data;
  final VoidCallback? onDeleteTap;

  const _WordCell({
    super.key,
    required this.nr,
    required this.data,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.colors.onSurfaceNeutralOpaqueLv1;
    final foregroundColor = theme.colors.textOnPrimaryLevel0;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 56),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        textStyle: theme.textTheme.bodyLarge?.copyWith(color: foregroundColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 16),
            Text('${nr.toString().padLeft(2, '0')}.'),
            const SizedBox(width: 6),
            Text(data),
            if (onDeleteTap != null)
              XButton(onTap: onDeleteTap)
            else
              const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _WordField extends StatelessWidget {
  final List<String> words;
  final TextEditingController controller;
  final FocusNode focusNode;
  final AutocompleteOnSelected<String> onSelected;

  const _WordField({
    required this.words,
    required this.controller,
    required this.focusNode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Note. TextField wants to take as much horizontal space
    // as possible. That's why we have to constraint it here.
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 120),
      child: VoicesAutocomplete<String>(
        textEditingController: controller,
        focusNode: focusNode,
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const [];
          }

          return words
              .where((element) => element.startsWith(textEditingValue.text))
              .take(10);
        },
        onSelected: onSelected,
      ),
    );
  }
}
