import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;

  const SearchTextField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250, maxHeight: 56),
      child: VoicesTextField(
        decoration: VoicesTextFieldDecoration(
          hintText: hintText,
          prefixIcon: VoicesAssets.icons.search.buildIcon(
            color: Theme.of(context).colors.iconsForeground,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) => _handleSearchQuery(context, value, true),
        onChanged: (value) => _handleSearchQuery(context, value, false),
      ),
    );
  }

  void _handleSearchQuery(
    BuildContext context,
    String value,
    bool isSubmitted,
  ) {
    final event = SearchQueryChangedEvent(value, isSubmitted: isSubmitted);
    context.read<WorkspaceBloc>().add(event);
  }
}
