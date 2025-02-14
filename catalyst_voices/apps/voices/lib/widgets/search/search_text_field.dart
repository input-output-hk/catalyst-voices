import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = void Function({
  required String searchValue,
  required bool isSubmitted,
});

class SearchTextField extends StatelessWidget {
  final String hintText;
  final SearchCallback onSearch;
  final double width;
  final double height;

  const SearchTextField({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.width = 250,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width, maxHeight: height),
      child: VoicesTextField(
        decoration: VoicesTextFieldDecoration(
          hintText: hintText,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          prefixIcon: VoicesAssets.icons.search.buildIcon(
            color: Theme.of(context).colors.iconsForeground,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) => _handleSearchQuery(
          searchValue: value,
          isSubmitted: true,
        ),
        onChanged: (value) => _handleSearchQuery(
          searchValue: value,
          isSubmitted: false,
        ),
      ),
    );
  }

  void _handleSearchQuery({
    required String? searchValue,
    required bool isSubmitted,
  }) {
    if (searchValue == null) return;

    final trimmedValue = searchValue.trim();
    if (trimmedValue.isEmpty) return;

    onSearch(searchValue: trimmedValue, isSubmitted: isSubmitted);
  }
}
