import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/common/animated_expand_chevron.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

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

class NavigationPopButton extends StatelessWidget {
  const NavigationPopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LeftArrowButton(
      onTap: () => unawaited(Navigator.maybeOf(context)?.maybePop()),
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

class VoicesEditSaveButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEditing;
  final bool hasError;

  const VoicesEditSaveButton({
    super.key,
    this.onTap,
    required this.isEditing,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final text =
        isEditing ? context.l10n.cancelButtonText : context.l10n.editButtonText;

    if (hasError) {
      return VoicesFilledButton(
        backgroundColor: Theme.of(context).colorScheme.error,
        onTap: onTap,
        child: Text(text),
      );
    } else {
      return VoicesTextButton(
        onTap: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    }
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

class VoicesStartProposalButton extends StatelessWidget {
  const VoicesStartProposalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: () => const ProposalBuilderDraftRoute().go(context),
      child: Text(context.l10n.startProposal),
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

class ActionIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const ActionIconButton({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton.filled(
      onTap: onTap,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(10),
        backgroundColor: context.colors.onSurfacePrimary08,
        foregroundColor: context.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        iconSize: 18,
      ),
      child: child,
    );
  }
}

class ShareButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ShareButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.share.buildIcon(
        color: context.colorScheme.primary,
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final ValueChanged<bool>? onChanged;

  const FavoriteButton({
    super.key,
    this.isFavorite = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;

    return ActionIconButton(
      onTap: onChanged != null ? () => onChanged.call(!isFavorite) : null,
      child: CatalystSvgIcon.asset(
        isFavorite
            ? VoicesAssets.icons.starFilled.path
            : VoicesAssets.icons.starOutlined.path,
        color: context.colorScheme.primary,
      ),
    );
  }
}
