import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class DrawerToggleButton extends StatelessWidget {
  const DrawerToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
      child: const Icon(CatalystVoicesIcons.menu),
    );
  }
}

class NavigationPopButton extends StatelessWidget {
  const NavigationPopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: () => unawaited(Navigator.maybeOf(context)?.maybePop()),
      child: const Icon(CatalystVoicesIcons.arrow_narrow_left),
    );
  }
}
