import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Voices implementation of material [Autocomplete] widget.
class VoicesAutocomplete<T extends Object> extends StatelessWidget {
  /// [RawAutocomplete.optionsBuilder].
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// [RawAutocomplete.onSelected]
  final AutocompleteOnSelected<T>? onSelected;

  /// [RawAutocomplete.displayStringForOption].
  final AutocompleteOptionToString<T> displayStringForOption;

  /// [RawAutocomplete.textEditingController]
  final TextEditingController? textEditingController;

  /// [RawAutocomplete.focusNode]
  final FocusNode? focusNode;

  const VoicesAutocomplete({
    super.key,
    required this.optionsBuilder,
    this.onSelected,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.textEditingController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      textEditingController: textEditingController,
      focusNode: focusNode,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return VoicesTextField(
          controller: textEditingController,
          focusNode: focusNode,
          maxLines: 1,
          onFieldSubmitted: (value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return _VoicesAutocompletionOptions<T>(
          options: options,
          onSelected: onSelected,
          displayStringForOption: displayStringForOption,
        );
      },
    );
  }
}

class _VoicesAutocompletionOptions<T extends Object> extends StatelessWidget {
  final Iterable<T> options;
  final AutocompleteOnSelected<T> onSelected;
  final AutocompleteOptionToString<T> displayStringForOption;

  const _VoicesAutocompletionOptions({
    required this.options,
    required this.onSelected,
    required this.displayStringForOption,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Material(
            color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
            elevation: 2,
            borderRadius: BorderRadius.circular(4),
            clipBehavior: Clip.antiAlias,
            child: Wrap(
              children: options.map(
                (option) {
                  return _VoicesAutocompletionOption<T>(
                    option: option,
                    onSelected: onSelected,
                    displayStringForOption: displayStringForOption,
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _VoicesAutocompletionOption<T extends Object> extends StatelessWidget {
  final T option;
  final AutocompleteOnSelected<T> onSelected;
  final AutocompleteOptionToString<T> displayStringForOption;

  const _VoicesAutocompletionOption({
    required this.option,
    required this.onSelected,
    required this.displayStringForOption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.textOnPrimaryLevel0;

    return InkWell(
      onTap: () => onSelected(option),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          displayStringForOption(option),
          style: theme.textTheme.bodyMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
