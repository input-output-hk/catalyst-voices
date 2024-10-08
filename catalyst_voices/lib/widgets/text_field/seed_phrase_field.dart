import 'package:catalyst_voices/widgets/text_field/voices_autocomplete.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

final class SeedPhraseFieldController extends ValueNotifier<List<String>> {
  SeedPhraseFieldController([super._value = const <String>[]]);
}

class SeedPhraseField extends StatefulWidget {
  final SeedPhraseFieldController? controller;
  final ValueChanged<List<String>>? onChanged;

  const SeedPhraseField({
    super.key,
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
                    return _WordCell(
                      key: ValueKey('Word${index}CellKey'),
                      nr: index + 1,
                      data: element,
                    );
                  },
                ),
                // TODO(damian): if not finished
                // TODO(damian): handle deleting words
                _WordField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  onSelected: _appendWord,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _appendWord(String data) {
    _textEditingController.clear();
    // TODO(damian): if not finished
    _focusNode.requestFocus();

    _effectiveController.value = [
      ..._effectiveController.value,
      data,
    ];

    widget.onChanged?.call(_effectiveController.value);
  }
}

class _WordCell extends StatelessWidget {
  final int nr;
  final String data;

  const _WordCell({
    super.key,
    required this.nr,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.colors.onSurfaceNeutralOpaqueLv1;
    final foregroundColor = theme.colors.textOnPrimaryLevel0;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(4),
      textStyle: theme.textTheme.bodyLarge?.copyWith(color: foregroundColor),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${nr.toString().padLeft(2, '0')}.'),
            const SizedBox(width: 6),
            Text(data),
          ],
        ),
      ),
    );
  }
}

class _WordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final AutocompleteOnSelected<String> onSelected;

  const _WordField({
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

          return SeedPhrase.wordList
              .where((element) => element.startsWith(textEditingValue.text))
              .take(10);
        },
        onSelected: onSelected,
      ),
    );
  }
}
