import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionsTabsGroup extends StatelessWidget {
  final ActionsPageTab selectedTab;
  final ValueChanged<ActionsPageTab?> onChanged;

  const ActionsTabsGroup({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const _ActionTypesText(),
        _Actions(
          selectedTab: selectedTab,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final ActionsPageTab selectedTab;
  final ValueChanged<ActionsPageTab?> onChanged;

  const _Actions({
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: ActionsPageTab.values.map((tab) {
        final isSelected = tab == selectedTab;
        return _Tab(
          name: tab.localizedName(context),
          isSelected: isSelected,
          onTap: () => isSelected ? onChanged(null) : onChanged(tab),
        );
      }).toList(),
    );
  }
}

class _ActionTypesText extends StatelessWidget {
  const _ActionTypesText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.actionTypes,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback? onTap;

  const _Tab({
    required this.name,
    required this.isSelected,
    this.onTap,
  });

  Set<WidgetState> get _states => {
    if (isSelected) WidgetState.selected,
  };

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      onTap: onTap,
      content: Text(
        name,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel0,
        ),
      ),
      leading: _leadingIcon(context).resolve(_states),
      backgroundColor: _backgroundColor(context).resolve(_states),
    );
  }

  WidgetStateProperty<Color?> _backgroundColor(BuildContext context) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return context.colors.primaryContainer;
      }
      return null;
    });
  }

  WidgetStateProperty<Widget?> _leadingIcon(BuildContext context) {
    return WidgetStateProperty.resolveWith<Widget?>((states) {
      if (states.contains(WidgetState.selected)) {
        return VoicesAssets.icons.check.buildIcon();
      }
      return null;
    });
  }
}
