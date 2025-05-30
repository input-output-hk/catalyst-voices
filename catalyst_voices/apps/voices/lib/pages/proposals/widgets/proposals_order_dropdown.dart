import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsOrderDropdown extends StatelessWidget {
  const ProposalsOrderDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, ProposalsStateOrderDropdown>(
      selector: (state) => state.orderDropdown,
      builder: (context, state) {
        return _ProposalsOrderDropdown(
          items: state.items,
          selected: state.selectedOrder,
          isEnabled: state.isEnabled,
        );
      },
    );
  }
}

class _ProposalsOrderDropdown extends StatelessWidget {
  final List<ProposalsDropdownOrderItem> items;
  final ProposalsOrder? selected;
  final bool isEnabled;

  const _ProposalsOrderDropdown({
    required this.items,
    required this.selected,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): FilterByDropdown should have more customization
    // options. Refactor to something custom.
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outlineBorderVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: FilterByDropdown<ProposalsOrder>(
        items: items.map(
          (item) {
            return VoicesDropdownMenuEntry(
              value: item.value,
              label: item.localizedName(context),
              context: context,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            );
          },
        ).toList(),
        value: selected,
        onChanged: isEnabled
            ? (value) => context.read<ProposalsCubit>().changeOrder(value, resetProposals: true)
            : null,
        foregroundColor: context.colors.textOnPrimaryLevel0,
        leadingIcon: VoicesAssets.icons.sortDescending.buildIcon(size: 8),
        insertByAll: false,
      ),
    );
  }
}
