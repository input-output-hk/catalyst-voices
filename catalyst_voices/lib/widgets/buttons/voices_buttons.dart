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

class LeftArrowButton extends StatelessWidget {
  final VoidCallback? onTap;

  const LeftArrowButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: const Icon(CatalystVoicesIcons.arrow_narrow_left),
    );
  }
}

class RightArrowButton extends StatelessWidget {
  final VoidCallback? onTap;

  const RightArrowButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: const Icon(CatalystVoicesIcons.arrow_narrow_right),
    );
  }
}

class ChevronDownButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ChevronDownButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: const Icon(CatalystVoicesIcons.chevron_down),
    );
  }
}

class ChevronRightButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ChevronRightButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: const Icon(CatalystVoicesIcons.chevron_right),
    );
  }
}

class ChevronExpandButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback? onTap;

  const ChevronExpandButton({
    super.key,
    this.isOpen = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? ChevronDownButton(onTap: onTap)
        : ChevronRightButton(onTap: onTap);
  }
}

class NavigationPopButton extends StatelessWidget {
  const NavigationPopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LeftArrowButton(
      onTap: () => unawaited(Navigator.maybeOf(context)?.maybePop()),
    );
  }
}
