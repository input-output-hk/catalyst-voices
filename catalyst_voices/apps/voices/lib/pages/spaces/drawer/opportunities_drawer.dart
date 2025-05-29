import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/spaces/drawer/session_account_drawer_catalyst_id.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class OpportunitiesDrawer extends StatelessWidget {
  const OpportunitiesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoicesDrawer(
      width: 488,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            SizedBox(height: 30),
            _Description(),
            SizedBox(height: 20),
            _BecomeReviewerCard(),
            SizedBox(height: 20),
            _RegisterAsVoter(),
          ],
        ),
      ),
    );
  }
}

class _BecomeReviewerCard extends StatelessWidget with LaunchUrlMixin {
  const _BecomeReviewerCard();

  @override
  Widget build(BuildContext context) {
    return _OpportunityCard(
      background: VoicesAssets.images.opportunities.reviewer.path,
      widthFactor: 0.6,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.turnOpinionsIntoActions,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.primary,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          const _CopyCatalystIdTipText(),
          const SizedBox(height: 16),
          const SessionAccountDrawerCatalystId(),
          const SizedBox(height: 20),
          _OpportunityActionButton(
            onTap: () async {
              await launchUri(VoicesConstants.becomeReviewerUrl.getUri());
            },
            title: context.l10n.becomeReviewer,
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
          ),
        ],
      ),
    );
  }
}

class _CopyCatalystIdTipText extends StatelessWidget {
  const _CopyCatalystIdTipText();

  @override
  Widget build(BuildContext context) {
    return TipText(
      context.l10n.tipCopyCatalystIdForReviewTool,
      style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textOnPrimaryLevel1),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.newUpdates,
      style: context.textTheme.bodyLarge,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.myOpportunities,
          style: context.textTheme.titleLarge,
        ),
        CloseButton(
          onPressed: () => Navigator.maybeOf(context)?.pop(),
        ),
      ],
    );
  }
}

class _OpportunityActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Widget? trailing;

  const _OpportunityActionButton({
    this.onTap,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      trailing: trailing,
      child: Text(title),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final String background;
  final double widthFactor;
  final Alignment alignment;
  final Widget child;

  const _OpportunityCard({
    required this.background,
    required this.widthFactor,
    required this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CatalystImage.asset(background).image,
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: child,
      ),
    );
  }
}

class _RegisterAsVoter extends StatelessWidget with LaunchUrlMixin {
  const _RegisterAsVoter();

  @override
  Widget build(BuildContext context) {
    return _OpportunityCard(
      background: VoicesAssets.images.opportunities.voter.path,
      widthFactor: 0.55,
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            context.l10n.f14Voting,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.primary,
              height: 1,
            ),
          ),
          const SizedBox(height: 28),
          _OpportunityActionButton(
            onTap: () async {
              await launchUri(
                VoicesConstants.votingRegistrationUrl.getUri(),
              );
            },
            title: context.l10n.votingRegistration,
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
