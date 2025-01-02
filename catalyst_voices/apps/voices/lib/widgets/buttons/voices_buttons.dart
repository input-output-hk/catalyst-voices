import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/common/animated_expand_chevron.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DrawerToggleButton extends StatelessWidget {
  const DrawerToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      key: const Key('DrawerButton'),
      onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
      child: VoicesAssets.icons.menu.buildIcon(),
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
      child: VoicesAssets.icons.arrowNarrowLeft.buildIcon(),
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
      child: VoicesAssets.icons.arrowNarrowRight.buildIcon(),
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
      child: VoicesAssets.icons.chevronDown.buildIcon(),
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
      child: VoicesAssets.icons.chevronRight.buildIcon(),
    );
  }
}

class ChevronExpandButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onTap;

  const ChevronExpandButton({
    super.key,
    this.isExpanded = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: AnimatedExpandChevron(isExpanded: isExpanded),
    );
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

class XButton extends StatelessWidget {
  final VoidCallback? onTap;

  const XButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.x.buildIcon(),
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  final VoidCallback? onTap;

  const MoreOptionsButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.dotsVertical.buildIcon(),
    );
  }
}

/// A "Learn More" button that redirects usually to an external content.
class VoicesLearnMoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoicesLearnMoreButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      key: const Key('LearnMoreButton'),
      trailing: VoicesAssets.icons.externalLink.buildIcon(),
      onTap: onTap,
      child: Text(context.l10n.learnMore),
    );
  }
}

class VoicesNextButton extends StatelessWidget {
  final VoidCallback? onTap;

  const VoicesNextButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: Text(context.l10n.next),
    );
  }
}

class VoicesBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const VoicesBackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: onTap,
      child: Text(context.l10n.back),
    );
  }
}
