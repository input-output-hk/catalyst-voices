import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalCollaboratorBannerAcceptButton extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const ProposalCollaboratorBannerAcceptButton({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.filled(
        style: style,
        onTap: onTap,
        child: VoicesAssets.icons.check.buildIcon(),
      ),
      sm: (context) => VoicesFilledButton(
        style: style,
        onTap: onTap,
        child: Text(message),
      ),
    );
  }
}

class ProposalCollaboratorBannerRejectButton extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const ProposalCollaboratorBannerRejectButton({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.outlined(
        style: style,
        onTap: onTap,
        child: VoicesAssets.icons.x.buildIcon(),
      ),
      sm: (context) => VoicesOutlinedButton(
        style: style,
        onTap: onTap,
        child: Text(message),
      ),
    );
  }
}

class ProposalCollaboratorDismissibleBanner extends StatelessWidget {
  final Widget icon;
  final String message;
  final Widget button;

  const ProposalCollaboratorDismissibleBanner({
    super.key,
    required this.icon,
    required this.message,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        border: Border(bottom: BorderSide(color: Theme.of(context).colors.outlineBorder)),
      ),
      child: AffixDecorator(
        // Reserve space for the 'x' button to have symmetry.
        prefix: const SizedBox.square(dimension: 28),
        suffix: VoicesIconButton(
          child: VoicesAssets.icons.x.buildIcon(
            size: 28,
            color: Theme.of(context).colors.iconsPrimary,
          ),
          onTap: () => context.read<ProposalViewerCubit>().dismissCollaboratorBanner(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconTheme.of(context).copyWith(size: 28),
              child: icon,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: MarkdownText(
                MarkdownData(message),
                pStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 16),
            button,
          ],
        ),
      ),
    );
  }
}

class ProposalCollaboratorPendingBanner extends StatelessWidget {
  final String message;
  final Widget acceptButton;
  final Widget rejectButton;

  const ProposalCollaboratorPendingBanner({
    super.key,
    required this.message,
    required this.acceptButton,
    required this.rejectButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        border: Border(bottom: BorderSide(color: Theme.of(context).colors.outlineBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VoicesAssets.icons.userGroup.buildIcon(
            size: 28,
            color: Theme.of(context).colors.iconsPrimary,
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 20),
          acceptButton,
          const SizedBox(width: 8),
          rejectButton,
        ],
      ),
    );
  }
}
