import 'dart:async';

import 'package:catalyst_voices/widgets/scrollbar/voices_scrollbar.dart';
import 'package:catalyst_voices/widgets/text_field/voices_autocomplete.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeedPhraseField extends StatefulWidget {
  final int wordsCount;
  final List<String> wordList;
  final SeedPhraseFieldController? controller;
  final FocusNode? focusNode;
  final ValueChanged<List<SeedPhraseWord>>? onChanged;

  const SeedPhraseField({
    super.key,
    this.wordsCount = 12,
    this.wordList = const [],
    this.controller,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<SeedPhraseField> createState() => _SeedPhraseFieldState();
}

final class SeedPhraseFieldController extends ValueNotifier<List<SeedPhraseWord>> {
  SeedPhraseFieldController([super._value = const <SeedPhraseWord>[]]);

  List<SeedPhraseWord> get words {
    return value;
  }

  set words(List<SeedPhraseWord> words) {
    value = words;
  }

  void clear() {
    value = const [];
  }
}

class _DeleteLastWordAction extends Action<_DeleteLastWordIntent> {
  final VoidCallback onInvoke;
  final TextEditingController textEditingController;
  final SeedPhraseFieldController seedPhraseFieldController;

  _DeleteLastWordAction({
    required this.onInvoke,
    required this.textEditingController,
    required this.seedPhraseFieldController,
  });

  @override
  Object? invoke(_DeleteLastWordIntent intent) {
    onInvoke();
    return null;
  }

  @override
  bool isEnabled(_DeleteLastWordIntent intent) {
    if (textEditingController.text.isNotEmpty) {
      return false;
    }

    if (seedPhraseFieldController.value.isEmpty) {
      return false;
    }

    return true;
  }
}

class _DeleteLastWordIntent extends Intent {
  const _DeleteLastWordIntent();
}

class _DeleteShortcut extends StatelessWidget {
  final VoidCallback onDeleteLastWord;
  final TextEditingController controller;
  final SeedPhraseFieldController seedPhraseFieldController;
  final Widget child;

  const _DeleteShortcut({
    required this.onDeleteLastWord,
    required this.controller,
    required this.seedPhraseFieldController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.backspace): const _DeleteLastWordIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _DeleteLastWordIntent: _DeleteLastWordAction(
            onInvoke: onDeleteLastWord,
            textEditingController: controller,
            seedPhraseFieldController: seedPhraseFieldController,
          ),
        },
        child: child,
      ),
    );
  }
}

class _SeedPhraseFieldState extends State<SeedPhraseField> {
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  final _wordFieldKey = GlobalKey();

  FocusNode? _focusNode;

  SeedPhraseFieldController? _controller;

  SeedPhraseFieldController get _effectiveController {
    return widget.controller ?? (_controller ??= SeedPhraseFieldController());
  }

  FocusNode get _effectiveFocusNode {
    return widget.focusNode ?? (_focusNode ??= FocusNode());
  }

  bool get _isCompleted {
    return _effectiveController.value.length == widget.wordsCount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _DeleteShortcut(
      onDeleteLastWord: _deleteLastWord,
      controller: _textEditingController,
      seedPhraseFieldController: _effectiveController,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colors.outlineBorder,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        position: DecorationPosition.foreground,
        child: VoicesScrollbar(
          mainAxisMargin: 16,
          controller: _scrollController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            controller: _scrollController,
            child: ValueListenableBuilder(
              valueListenable: _effectiveController,
              builder: (context, value, _) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...value.map(
                      (element) {
                        return _WordCell(
                          key: ValueKey('Word${element.nr}CellKey'),
                          nr: element.nr,
                          data: element.data,
                        );
                      },
                    ),
                    Offstage(
                      offstage: _isCompleted,
                      child: _WordField(
                        key: _wordFieldKey,
                        words: widget.wordList,
                        controller: _textEditingController,
                        focusNode: _effectiveFocusNode,
                        onSelected: _appendWord,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();

    _focusNode?.dispose();
    _focusNode = null;

    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  void _appendWord(String data) {
    final nextNr = _effectiveController.value.length + 1;
    final word = SeedPhraseWord(data, nr: nextNr);
    final words = [
      ..._effectiveController.value,
      word,
    ];

    _textEditingController.clear();

    if (words.length != widget.wordsCount) {
      _effectiveFocusNode.requestFocus();
    }

    _effectiveController.value = words;
    widget.onChanged?.call(words);

    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureWordFieldVisible());
  }

  void _deleteAt(int index) {
    final words = [..._effectiveController.value]..removeAt(index);

    if (words.length == widget.wordsCount - 1) {
      _textEditingController.clear();
      _effectiveFocusNode.requestFocus();
    }

    _effectiveController.value = words;
    widget.onChanged?.call(words);
  }

  void _deleteLastWord() {
    _deleteAt(_effectiveController.value.length - 1);
  }

  void _ensureWordFieldVisible() {
    final fieldContext = _wordFieldKey.currentContext;
    if (fieldContext != null) {
      unawaited(Scrollable.ensureVisible(fieldContext));
    }
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
    super.key,
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

          return words.where((element) => element.startsWith(textEditingValue.text)).take(10);
        },
        onSelected: onSelected,
        autovalidateMode: AutovalidateMode.always,
        textValidator: (value) {
          return switch (value) {
            final value when value.isEmpty => const VoicesTextFieldValidationResult.none(),
            final value when !words.any((word) => word.startsWith(value)) =>
              VoicesTextFieldValidationResult.error(
                context.l10n.invalidSeedPhraseWord,
              ),
            _ => const VoicesTextFieldValidationResult.none(),
          };
        },
        showValidationStatusIcon: false,
      ),
    );
  }
}
