import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceProposalFilters extends StatelessWidget {
  const WorkspaceProposalFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, WorkspaceFilters>(
      selector: (state) => state.userProposals.currentFilter,
      builder: (context, currentFilter) {
        return _WorkspaceProposalFilters(
          filter: currentFilter,
          onTap: (filter) => _changeFilter(context, filter),
        );
      },
    );
  }

  void _changeFilter(BuildContext context, WorkspaceFilters filter) {
    context.read<WorkspaceBloc>().add(ChangeWorkspaceFilters(filters: filter));
  }
}

class _FilterChip extends StatelessWidget {
  final WorkspaceFilters selectedFilter;
  final WorkspaceFilters filter;
  final ValueChanged<WorkspaceFilters> onTap;

  const _FilterChip({
    required this.selectedFilter,
    required this.filter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip(
      leading: filter.leading(selectedFilter),
      content: Text(filter.localizedName(context.l10n)),
      backgroundColor: filter.backgroundColor(context, selectedFilter),
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap(filter),
    );
  }
}

class _WorkspaceProposalFilters extends StatelessWidget {
  final WorkspaceFilters filter;
  final ValueChanged<WorkspaceFilters> onTap;

  const _WorkspaceProposalFilters({required this.filter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        spacing: 12,
        children: WorkspaceFilters.values
            .map(
              (value) => _FilterChip(
                selectedFilter: filter,
                filter: value,
                onTap: onTap,
              ),
            )
            .toList(),
      ),
    );
  }
}

extension on WorkspaceFilters {
  Color? backgroundColor(BuildContext context, WorkspaceFilters selectedFilter) {
    if (selectedFilter == this) {
      return context.colors.primaryContainer;
    }
    return null;
  }

  Widget? leading(WorkspaceFilters selectedFilter) {
    if (selectedFilter == this) {
      return VoicesAssets.icons.check.buildIcon();
    }
    return null;
  }
}
