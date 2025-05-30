import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
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
    return ColoredBox(
      color: Colors.orange,
      child: FilterByDropdown<ProposalsOrder>(
        items: items.map(
          (item) {
            return VoicesDropdownMenuEntry(
              value: item.value,
              label: item.localizedName(context),
              context: context,
            );
          },
        ).toList(),
        value: selected,
        onChanged: isEnabled
            ? (value) => context.read<ProposalsCubit>().changeOrder(value, resetProposals: true)
            : null,
      ),
    );
  }
}
