import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/text/voting_start_at_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          SizedBox(height: 24),
          Wrap(
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
          BlocSelector<SessionCubit, SessionState, CatalystId?>(
            selector: (state) {
              return state.account?.catalystId;
            },
            builder: (context, state) {
              return VoicesTextButton(
                onTap: () {
                  unawaited(
                    Clipboard.setData(
                      ClipboardData(text: state.toString()),
                    ),
                  );

                  _showTooltip(context);
                },
                leading: VoicesAssets.icons.duplicate.buildIcon(),
                child: Text(
                  context.l10n.copyMyCatalystId,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          VoicesFilledButton(
            onTap: () {
              // TODO(LynxLynxx): add url;
              // launchUri();
            },
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
            child: Text(
              context.l10n.becomeReviewer,
            ),
          ),
        ],
      ),
    );
  }

  void _showTooltip(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    final position = box.localToGlobal(Offset.zero);

    final tooltipPosition = Offset(
      position.dx,
      position.dy - 10,
    );
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: tooltipPosition.dx,
        top: tooltipPosition.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              context.l10n.copied,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
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
              color: context.colors.textOnPrimaryLevel0,
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
    return BlocSelector<DiscoveryCubit, DiscoveryState, DateTime>(
      selector: (state) {
        return state.currentCampaign.votingStartsAt;
      },
      builder: (context, votingStartDate) {
        return _StayInvolvedCard(
          icon: VoicesAssets.icons.vote,
          title: context.l10n.votingRegistrationForF14,
          description: context.l10n.stayInvolvedVoterDescription,
          actions: VoicesFilledButton(
            child: Text(
              context.l10n.votingRegistration,
            ),
            onTap: () {
              // TODO(LynxLynxx): add url;
              // launchUri();
            },
          ),
          additionalInfo: VotingStartAtTimeText(
            data: votingStartDate,
          ),
        );
      },
    );
  }
}
