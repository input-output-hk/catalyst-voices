import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/copy_catalyst_id_button.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: Padding(
        padding: const EdgeInsets.only(
          top: 28,
          left: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 198,
              child: Text(
                context.l10n.turnOpinionsIntoActions,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            CopyCatalystIdButton(onTap: () => _handleCopyCatalystId(context)),
            const SizedBox(height: 4),
            _OpportunityActionButton(
              onTap: () async {
                await launchUri(VoicesConstants.becomeReviewerUrl.getUri());
              },
              title: context.l10n.becomeReviewer,
              trailing: VoicesAssets.icons.externalLink.buildIcon(),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(CatalystId? text) {
    unawaited(Clipboard.setData(ClipboardData(text: text.toString())));
  }

  void _handleCopyCatalystId(BuildContext context) {
    final catalystId = context.read<SessionCubit>().state.account?.catalystId;
    _copyToClipboard(catalystId);
    _showSuccessSnackbar(context);
  }

  void _showSuccessSnackbar(BuildContext context) {
    VoicesSnackBar.hideCurrent(context);

    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      message: context.l10n.copied,
    ).show(context);
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
  final Widget child;

  const _OpportunityCard({
    required this.background,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(const Size(426, 260)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CatalystImage.asset(background).image,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

class _RegisterAsVoter extends StatelessWidget with LaunchUrlMixin {
  const _RegisterAsVoter();

  @override
  Widget build(BuildContext context) {
    return _OpportunityCard(
      background: VoicesAssets.images.opportunities.voter.path,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 44,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 198,
                child: Text(
                  context.l10n.f14Voting,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _OpportunityActionButton(
                onTap: () async {
                  await launchUri(
                    VoicesConstants.votingRegistrationUrl.getUri(),
                  );
                },
                title: context.l10n.votingRegistration,
                trailing: VoicesAssets.icons.externalLink.buildIcon(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
