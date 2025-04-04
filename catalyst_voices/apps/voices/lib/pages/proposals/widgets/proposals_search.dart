import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsSearch extends StatelessWidget {
  const ProposalsSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchTextField(
      key: const Key('SearchProposalsField'),
      hintText: context.l10n.searchProposals,
      showClearButton: true,
      onSearch: ({
        required searchValue,
        required isSubmitted,
      }) {
        print('searchValue[$searchValue], isSubmitted[$isSubmitted]');
        context.read<ProposalsCubit>().changeSearchValue(searchValue);
      },
    );
  }
}
