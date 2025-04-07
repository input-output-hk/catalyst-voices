import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/copy_catalyst_id_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/text/voting_start_at_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StayInvolved extends StatelessWidget {
  const StayInvolved({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 120, vertical: 72),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(),
          SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _ReviewerCard(),
              _VoterCard(),
            ],
          ),
        ],
      ),
    );
  }
}

class __ReviewerCardState extends State<_ReviewerCard> {
  @override
  Widget build(BuildContext context) {
    return _StayInvolvedCard(
      icon: VoicesAssets.icons.clipboardCheck,
      title:
          // ignore: lines_longer_than_80_chars
          '${context.l10n.turnOpinionsIntoActions} ${context.l10n.becomeReviewer}!',
      description: context.l10n.stayInvolvedReviewerDescription,
      actions: Row(
        children: [
          CopyCatalystIdButton(
            onTap: () => _handleCopyCatalystId(context),
          ),
          const SizedBox(height: 4),
          _StayInvolvedActionButton(
            title: context.l10n.becomeReviewer,
            // TODO(LynxLynxx): add url;
            urlString: 'https://google.com',
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
          ),
        ],
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.stayInvolved,
      style: context.textTheme.headlineMedium,
    );
  }
}

class _ReviewerCard extends StatefulWidget {
  const _ReviewerCard();

  @override
  State<_ReviewerCard> createState() => __ReviewerCardState();
}

class _StayInvolvedActionButton extends StatelessWidget with LaunchUrlMixin {
  final String title;
  final String urlString;
  final Widget? trailing;

  const _StayInvolvedActionButton({
    required this.title,
    required this.urlString,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: _handleUrlTap,
      trailing: trailing,
      child: Text(title),
    );
  }

  Future<void> _handleUrlTap() async {
    final url = urlString.getUri();
    await launchUri(url);
  }
}

class _StayInvolvedCard extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String description;
  final Widget actions;
  final Widget? additionalInfo;

  const _StayInvolvedCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actions,
    this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 588,
      height: 550,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD1EAFF),
            Color(0xFFCAD6FE),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon.buildIcon(size: 53),
          const SizedBox(height: 22),
          Text(
            title,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          if (additionalInfo != null) ...[
            const SizedBox(height: 12),
            additionalInfo!,
          ],
          const SizedBox(height: 20),
          actions,
        ],
      ),
    );
  }
}

class _VoterCard extends StatelessWidget {
  const _VoterCard();

  @override
  Widget build(BuildContext context) {
    return _StayInvolvedCard(
      icon: VoicesAssets.icons.vote,
      title: context.l10n.votingRegistrationForF14,
      description: context.l10n.stayInvolvedVoterDescription,
      actions: _StayInvolvedActionButton(
        title: context.l10n.votingRegistration,
        // TODO(LynxLynxx): add url;
        urlString: 'https://google.com',
      ),
      additionalInfo: BlocSelector<DiscoveryCubit, DiscoveryState, DateTime?>(
        selector: (state) {
          return state.currentCampaign.votingStartsAt;
        },
        builder: (context, date) {
          return date == null
              ? const SizedBox.shrink()
              : VotingStartAtTimeText(
                  data: date,
                );
        },
      ),
    );
  }
}
