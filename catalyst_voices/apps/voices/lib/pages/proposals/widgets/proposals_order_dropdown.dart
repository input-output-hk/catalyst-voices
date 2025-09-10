import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/menu/voices_raw_popup_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
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

class _DropdownButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _DropdownButton({
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Opacity(
      // TODO(damian-molinski): this should be done using WidgetStateProperty
      opacity: isEnabled ? 1.0 : 0.3,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Material(
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
            side: BorderSide(color: context.colors.outlineBorderVariant),
          ),
          borderRadius: BorderRadius.circular(8),
          textStyle: (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
            color: context.colors.textOnPrimaryLevel0,
          ),
          child: IconTheme(
            data: IconThemeData(
              size: 18,
              color: context.colors.iconsForeground,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                child: AffixDecorator(
                  prefix: VoicesAssets.icons.sortDescending.buildIcon(),
                  suffix: VoicesAssets.icons.chevronDown.buildIcon(),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
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
    // TODO(damian-molinski): refactor this into standalone widget for easier re-use.
    return VoicesRawPopupMenuButton<ProposalsOrder>(
      buttonBuilder: (context, onTapCallback, {required isMenuOpen}) {
        final item = items.firstWhereOrNull((element) => element.isSelected);

        return _DropdownButton(
          onTap: isEnabled ? onTapCallback : null,
          child: Text(item?.localizedName(context) ?? context.l10n.defaultProposalsOrder),
        );
      },
      menuBuilder: (context) {
        return VoicesRawPopupMenu(
          padding: const EdgeInsets.symmetric(vertical: 8),
          constraints: const BoxConstraints(maxWidth: 260),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map(
              (item) {
                return VoicesListTile(
                  leading: Visibility.maintain(
                    visible: item.isSelected,
                    child: VoicesAssets.icons.check.buildIcon(color: context.colors.success),
                  ),
                  title: Text(item.localizedName(context)),
                  onTap: () => Navigator.of(context).pop(item.value),
                );
              },
            ).toList(),
          ),
        );
      },
      onSelected: (value) {
        context.read<ProposalsCubit>().changeOrder(value, resetProposals: true);
      },
      routeSettings: const RouteSettings(name: '/proposals-order-dropdown'),
    );
  }
}
