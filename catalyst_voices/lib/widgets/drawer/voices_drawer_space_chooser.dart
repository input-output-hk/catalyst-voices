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
      return VoicesDrawerChooserItem(
        icon: item.icon(),
        foregroundColor: item.foregroundColor(context),
        backgroundColor: item.backgroundColor(context),
      );
    } else {
      return const VoicesDrawerChooserItemPlaceholder();
    }
  }
}

extension _SpaceExt on Space {
  IconData icon() {
    switch (this) {
      case Space.ideas:
        return CatalystVoicesIcons.light_bulb;
      case Space.discovery:
        return CatalystVoicesIcons.shopping_cart;
      case Space.proposals:
        return CatalystVoicesIcons.fund;
      case Space.settings:
        return CatalystVoicesIcons.cog_gear;
    }
  }

  Color foregroundColor(BuildContext context) {
    switch (this) {
      case Space.ideas:
        return Theme.of(context).colorScheme.primary;
      case Space.discovery:
        return Theme.of(context).colorScheme.secondary;
      case Space.proposals:
        return Colors.white;
      case Space.settings:
        return Colors.white;
    }
  }

  Color backgroundColor(BuildContext context) {
    switch (this) {
      case Space.ideas:
        return Theme.of(context).colorScheme.primaryContainer;
      case Space.discovery:
        return Theme.of(context).colorScheme.secondaryContainer;
      case Space.proposals:
        return Colors.orange;
      case Space.settings:
        return Colors.green;
    }
  }
}
