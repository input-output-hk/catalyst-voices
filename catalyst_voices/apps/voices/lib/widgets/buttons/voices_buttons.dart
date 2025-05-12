import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/common/animated_expand_chevron.dart';
import 'package:catalyst_voices/widgets/modals/proposals/create_new_proposal_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchUrl(String url) {
  unawaited(launchUrl(url.getUri()));
}

class ActionIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool circle;
  final Widget child;

  const ActionIconButton({
    super.key,
    this.onTap,
    this.circle = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton.filled(
      onTap: onTap,
      style: circle
          ? IconButton.styleFrom(
              backgroundColor: context.colors.onSurfacePrimary08,
              foregroundColor: context.colorScheme.primary,
            )
          : IconButton.styleFrom(
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

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final bool circle;
  final ValueChanged<bool>? onChanged;

  const FavoriteButton({
    super.key,
    this.isFavorite = false,
    this.circle = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;

    return ActionIconButton(
      onTap: onChanged != null ? () => onChanged.call(!isFavorite) : null,
      circle: circle,
      child: CatalystSvgIcon.asset(
        isFavorite
            ? VoicesAssets.icons.starFilled.path
            : VoicesAssets.icons.starOutlined.path,
        color: context.colorScheme.primary,
      ),
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

class ReplyButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Size size;

  const ReplyButton({
    super.key,
    this.onTap,
    this.size = const Size.square(34),
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton.outlined(
      onTap: onTap,
      style: IconButton.styleFrom(
        iconSize: 18,
        minimumSize: size,
        maximumSize: size,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: VoicesAssets.icons.reply.buildIcon(),
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

class ShareButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool circle;

  const ShareButton({
    super.key,
    this.onTap,
    this.circle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ActionIconButton(
      onTap: onTap,
      circle: circle,
      child: VoicesAssets.icons.share.buildIcon(
        color: context.colorScheme.primary,
      ),
    );
  }
}

class VoicesBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? semanticsIdentifier;

  const VoicesBackButton({
    super.key,
    this.onTap,
    this.semanticsIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: onTap,
      child: Semantics(
        identifier: semanticsIdentifier ?? 'BackButton',
        child: Text(context.l10n.back),
      ),
    );
  }
}

class VoicesEditCancelButton extends StatelessWidget {
  final VoicesEditCancelButtonStyle style;
  final VoidCallback? onTap;
  final bool isEditing;
  final bool hasError;

  const VoicesEditCancelButton({
    super.key,
    this.style = VoicesEditCancelButtonStyle.text,
    this.onTap,
    required this.isEditing,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text =
        isEditing ? context.l10n.cancelButtonText : context.l10n.editButtonText;
    final textStyle = theme.textTheme.labelSmall!;

    if (hasError) {
      return VoicesFilledButton(
        backgroundColor: theme.colorScheme.error,
        onTap: onTap,
        child: Text(
          text,
          style: textStyle.copyWith(color: theme.colorScheme.onError),
        ),
      );
    }

    if (isEditing) {
      return VoicesTextButton(
        onTap: onTap,
        child: Text(
          text,
          style: textStyle.copyWith(color: theme.colorScheme.error),
        ),
      );
    }

    return switch (style) {
      VoicesEditCancelButtonStyle.text => VoicesTextButton(
          onTap: onTap,
          child: Text(text, style: textStyle),
        ),
      VoicesEditCancelButtonStyle.outlinedWithIcon => VoicesOutlinedButton(
          onTap: onTap,
          leading: VoicesAssets.icons.pencilAlt.buildIcon(),
          child: Text(
            text,
            style: textStyle.copyWith(color: theme.colorScheme.primary),
          ),
        ),
    };
  }
}

enum VoicesEditCancelButtonStyle {
  text,
  outlinedWithIcon,
}

/// A "Learn More" button that redirects usually to an external content.
class VoicesLearnMoreFilledButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoicesLearnMoreFilledButton({
    super.key,
    required this.onTap,
  });

  factory VoicesLearnMoreFilledButton.url({
    Key? key,
    required String url,
  }) {
    return VoicesLearnMoreFilledButton(
      key: key,
      onTap: () => _launchUrl(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('LearnMoreButton'),
      trailing: VoicesAssets.icons.externalLink.buildIcon(),
      onTap: onTap,
      child: Text(context.l10n.learnMore),
    );
  }
}

class VoicesLearnMoreTextButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoicesLearnMoreTextButton({
    super.key,
    required this.onTap,
  });

  factory VoicesLearnMoreTextButton.url({
    Key? key,
    required String url,
  }) {
    return VoicesLearnMoreTextButton(
      key: key,
      onTap: () => _launchUrl(url),
    );
  }

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
  final String? semanticsIdentifier;

  const VoicesNextButton({super.key, this.onTap, this.semanticsIdentifier});

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: Semantics(
        identifier: semanticsIdentifier ?? 'NextButton',
        child: Text(context.l10n.next),
      ),
    );
  }
}

class VoicesStartProposalButton extends StatelessWidget {
  const VoicesStartProposalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: () => unawaited(CreateNewProposalDialog.show(context)),
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
