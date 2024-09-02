import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
      onSelected: (value) => onChanged(value),
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
    return switch (this) {
      Space.ideas => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.light_bulb,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      Space.discovery => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.shopping_cart,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
      Space.proposals => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.fund,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      Space.settings => _VoicesDrawerSpaceChooserConfig(
          iconData: CatalystVoicesIcons.cog_gear,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
    };
  }
}
