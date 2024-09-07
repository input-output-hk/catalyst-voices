import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesDrawerSpaceChooser extends StatelessWidget {
  final Space currentSpace;
  final ValueChanged<Space> onChanged;

  const VoicesDrawerSpaceChooser({
    super.key,
    required this.currentSpace,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawerChooser<Space>(
      items: Space.values,
      selectedItem: currentSpace,
      onSelected: onChanged,
      itemBuilder: _itemBuilder,
      leading: IconButton(
        icon: const Icon(CatalystVoicesIcons.all_spaces_menu, size: 20),
        onPressed: () {},
      ),
    );
  }

  Widget _itemBuilder({
    required BuildContext context,
    required Space item,
    required bool isSelected,
  }) {
    if (isSelected) {
      final config = item._config(context);

      return VoicesDrawerChooserItem(
        icon: config.iconData,
        foregroundColor: config.foregroundColor,
        backgroundColor: config.backgroundColor,
      );
    } else {
      return const VoicesDrawerChooserItemPlaceholder();
    }
  }
}

final class _VoicesDrawerSpaceChooserConfig {
  final IconData iconData;
  final Color backgroundColor;
  final Color foregroundColor;

  _VoicesDrawerSpaceChooserConfig({
    required this.iconData,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}

extension _SpaceExt on Space {
  _VoicesDrawerSpaceChooserConfig _config(BuildContext context) {
    final theme = Theme.of(context);

    return switch (this) {
      Space.treasury => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.fund,
          backgroundColor: theme.colors.successContainer!,
          foregroundColor: theme.colors.iconsSuccess!,
        ),
      Space.discovery => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.light_bulb,
          backgroundColor: theme.colors.iconsSecondary!.withOpacity(0.16),
          foregroundColor: theme.colors.iconsSecondary!,
        ),
      Space.workspace => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.briefcase,
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.primary,
        ),
      Space.voting => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.vote,
          backgroundColor: theme.colors.warningContainer!,
          foregroundColor: theme.colors.iconsWarning!,
        ),
      Space.fundedProjects => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.flag,
          backgroundColor: theme.colors.iconsSecondary!.withOpacity(0.16),
          foregroundColor: theme.colors.iconsSecondary!,
        ),
    };
  }
}
