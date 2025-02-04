part of 'workspace_header.dart';

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
