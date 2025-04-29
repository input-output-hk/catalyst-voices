import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalsSearch extends StatefulWidget {
  const ProposalsSearch({super.key});

  @override
  State<ProposalsSearch> createState() => _ProposalsSearchState();
}

class _ProposalsSearchState extends State<ProposalsSearch> {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  Widget build(BuildContext context) {
    return SearchTextField(
      key: const Key('SearchProposalsField'),
      hintText: context.l10n.searchProposals,
      showClearButton: true,
      debouncer: _debouncer,
      onSearch: ({
        required searchValue,
        required isSubmitted,
      }) {
        context.read<ProposalsCubit>().updateSearchQuery(searchValue);
      },
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
