import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = void Function({
  required String searchValue,
  required bool isSubmitted,
});

class SearchTextField extends StatefulWidget {
  final String hintText;
  final SearchCallback onSearch;
  final double width;
  final double height;
  final bool showClearButton;
  final Debouncer? debouncer;

  const SearchTextField({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.width = 250,
    this.height = 56,
    this.showClearButton = false,
    this.debouncer,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _controller;
  Debouncer get _debouncer => widget.debouncer ?? Debouncer();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: widget.width, maxHeight: widget.height),
      child: VoicesTextField(
        controller: _controller,
        decoration: VoicesTextFieldDecoration(
          hintText: widget.hintText,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          prefixIcon: VoicesAssets.icons.search.buildIcon(
            color: Theme.of(context).colors.iconsForeground,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Offstage(
                offstage: !widget.showClearButton || value.text.isEmpty,
                child: VoicesTextButton(
                  key: const Key('SearchTextFieldResetButton'),
                  onTap: _clearTextFiled,
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.textOnPrimaryLevel0,
                  ),
                  child: Text(context.l10n.reset),
                ),
              );
            },
          ),
        ),
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) => _handleSearchQuery(
          searchValue: value,
          isSubmitted: true,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(SearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.debouncer != widget.debouncer) {
      _controller
        ..removeListener(_listenToTextField)
        ..addListener(_listenToTextField);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_listenToTextField);
  }

  void _clearTextFiled() {
    _controller.clear();
    widget.onSearch(searchValue: '', isSubmitted: false);
  }

  void _handleSearchQuery({
    required String? searchValue,
    required bool isSubmitted,
  }) {
    if (searchValue == null) return;

    final trimmedValue = searchValue.trim();
    if (trimmedValue.isEmpty) return;

    widget.onSearch(searchValue: trimmedValue, isSubmitted: isSubmitted);
  }

  void _listenToTextField() {
    _debouncer.run(
      () => _handleSearchQuery(
        searchValue: _controller.text,
        isSubmitted: false,
      ),
    );
  }
}
