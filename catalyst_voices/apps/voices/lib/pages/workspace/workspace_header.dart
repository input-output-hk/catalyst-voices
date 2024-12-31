import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceHeader extends StatelessWidget {
  const WorkspaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            _TitleText(),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SubtitleText(),
                      SizedBox(height: 16),
                      _DescriptionText(),
                      SizedBox(height: 32),
                      _DraftProposalButton(),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _SearchTextField(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _TabsSelector(),
          ],
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      Space.workspace.localizedName(context.l10n),
      style: theme.textTheme.headlineLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.myProposals,
      style: theme.textTheme.displaySmall?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.workspaceDescription,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }
}

class _DraftProposalButton extends StatelessWidget {
  const _DraftProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () async {
        final id = await context.read<WorkspaceBloc>().createNewDraftProposal();

        if (context.mounted) {
          ProposalBuilderRoute(proposalId: id).go(context);
        }
      },
      leading: VoicesAssets.icons.plus.buildIcon(),
      child: Text(context.l10n.newDraftProposal),
    );
  }
}

class _TabsSelector extends StatelessWidget {
  const _TabsSelector();

  @override
  Widget build(BuildContext context) {
    final tab = context.read<WorkspaceBloc>().state.tab;

    return DefaultTabController(
      length: WorkspaceTabType.values.length,
      initialIndex: tab.index,
      child: BlocListener<WorkspaceBloc, WorkspaceState>(
        listener: (context, state) {
          final index = state.tab.index;
          final tabController = DefaultTabController.of(context);

          if (tabController.index != index) {
            tabController.animateTo(index);
          }
        },
        listenWhen: (previous, current) => previous.tab != current.tab,
        child: BlocSelector<WorkspaceBloc, WorkspaceState,
            ({int draftProposalCount, int finalProposalCount})>(
          selector: (state) {
            return (
              draftProposalCount: state.draftProposalCount,
              finalProposalCount: state.finalProposalCount
            );
          },
          builder: (context, state) {
            return _Tabs(
              draftProposalCount: state.draftProposalCount,
              finalProposalCount: state.finalProposalCount,
            );
          },
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  final int draftProposalCount;
  final int finalProposalCount;

  const _Tabs({
    required this.draftProposalCount,
    required this.finalProposalCount,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      onTap: (index) {
        final tab = WorkspaceTabType.values[index];
        final event = TabChangedEvent(tab);
        context.read<WorkspaceBloc>().add(event);
      },
      tabs: [
        Tab(text: context.l10n.draftProposalsX(draftProposalCount)),
        Tab(text: context.l10n.finalProposalsX(finalProposalCount)),
      ],
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField();

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
        onFieldSubmitted: (value) {
          final event = SearchQueryChangedEvent(value, isSubmitted: true);
          context.read<WorkspaceBloc>().add(event);
        },
        onChanged: (value) {
          final event = SearchQueryChangedEvent(value);
          context.read<WorkspaceBloc>().add(event);
        },
      ),
    );
  }
}
