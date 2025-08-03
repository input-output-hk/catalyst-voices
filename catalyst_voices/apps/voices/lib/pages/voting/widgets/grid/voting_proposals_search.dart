import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VotingProposalsSearch extends StatefulWidget {
  const VotingProposalsSearch({super.key});

  @override
  State<VotingProposalsSearch> createState() => _VotingProposalsSearchState();
}

class _VotingProposalsSearchState extends State<VotingProposalsSearch> {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SearchTextField(
        key: const Key('SearchProposalsField'),
        hintText: context.l10n.searchProposals,
        showClearButton: true,
        debouncer: _debouncer,
        onSearch: ({
          required searchValue,
          required isSubmitted,
        }) {
          context.read<VotingCubit>().updateSearchQuery(searchValue);
        },
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
