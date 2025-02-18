import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_proposal_list_item.dart';
part 'my_proposals_list.dart';
part 'my_proposals_list_selector.dart';
part 'my_proposals_tab_selector.dart';
part 'my_proposals_tabs.dart';

class WorkspaceMyProposalsSelector extends StatelessWidget {
  const WorkspaceMyProposalsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myProposals,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: _MyProposalsTabSelector(),
                ),
                Positioned(
                  right: 4,
                  child: SearchTextField(
                    hintText: '${l10n.searchProposals}…',
                    onSearch: ({
                      required searchValue,
                      required isSubmitted,
                    }) {
                      final event = SearchQueryChangedEvent(
                        searchValue,
                        isSubmitted: isSubmitted,
                      );
                      context.read<WorkspaceBloc>().add(event);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: _MyProposalsListSelector(),
          ),
        ],
      ),
    );
  }
}
