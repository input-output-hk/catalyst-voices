import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 372),
      child: VoicesTextField(
        decoration: VoicesTextFieldDecoration(
          labelText: context.l10n.searchProposals,
          hintText: context.l10n.search,
          prefixIcon: VoicesAssets.icons.search.buildIcon(),
          filled: true,
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
