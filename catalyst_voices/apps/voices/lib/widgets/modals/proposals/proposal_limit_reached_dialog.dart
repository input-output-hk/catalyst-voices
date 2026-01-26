import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/tip_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProposalLimitReachedDialog extends StatelessWidget {
  final int currentSubmissions;
  final int maxSubmissions;
  final DateTime submissionCloseAt;

  const ProposalLimitReachedDialog({
    super.key,
    required this.currentSubmissions,
    required this.maxSubmissions,
    required this.submissionCloseAt,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPanelsDialog(
      secondary: const _LeftSide(),
      primary: _RightSide(
        currentSubmissions: currentSubmissions,
        maxSubmissions: maxSubmissions,
        date: submissionCloseAt,
      ),
      secondaryPadding: EdgeInsets.zero,
    );
  }

  static Future<void> show({
    required BuildContext context,
    required int currentSubmissions,
    required int maxSubmissions,
    required DateTime submissionCloseAt,
  }) async {
    await VoicesDialog.show<void>(
      context: context,
      builder: (context) => ProposalLimitReachedDialog(
        currentSubmissions: currentSubmissions,
        maxSubmissions: maxSubmissions,
        submissionCloseAt: submissionCloseAt,
      ),
      routeSettings: const RouteSettings(name: '/proposal-limit-reached'),
    );
  }
}

class _Countdown extends StatelessWidget {
  final DateTime date;

  const _Countdown({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCountdown(
      dateTime: date,
      builder:
          (
            context, {
            required ValueListenable<int> days,
            required ValueListenable<int> hours,
            required ValueListenable<int> minutes,
            required ValueListenable<int> seconds,
          }) => ListenableBuilder(
            listenable: Listenable.merge([days, hours, minutes, seconds]),
            builder: (context, _) => Text(
              context.l10n.catalystAppClosesIn(
                days.value,
                hours.value,
                minutes.value,
                seconds.value,
              ),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.headsUp,
      style: context.textTheme.displayMedium?.copyWith(
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _HeadsUpInfo extends StatelessWidget {
  final String text;

  const _HeadsUpInfo(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.withBullet(),
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
    );
  }
}

class _LeftSide extends StatefulWidget {
  const _LeftSide();

  @override
  State<_LeftSide> createState() => _LeftSideState();
}

class _LeftSideState extends State<_LeftSide> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CatalystImage.asset(
      VoicesAssets.images.trafficCone.path,
      fit: BoxFit.cover,
    );
  }
}

class _RightSide extends StatelessWidget with LaunchUrlMixin {
  final int currentSubmissions;
  final int maxSubmissions;
  final DateTime date;

  const _RightSide({
    required this.currentSubmissions,
    required this.maxSubmissions,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const _Header(),
        const SizedBox(height: 12),
        _Subheader(currentSubmissions: currentSubmissions),
        const SizedBox(height: 12),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint1),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint2(maxSubmissions)),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint3),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint4),
        const SizedBox(height: 32),
        VoicesLearnMoreFilledButton(uri: VoicesConstants.proposalPublishingDocsUrl.getUri()),
        const Spacer(),
        _Countdown(date: date),
        const SizedBox(height: 10),
        TipCard(
          headerText: context.l10n.proposalsLimitReachedCaptionTitle,
          tips: [
            context.l10n.proposalsLimitReachedCaptionText,
          ],
        ),
      ],
    );
  }
}

class _Subheader extends StatelessWidget {
  final int currentSubmissions;

  const _Subheader({required this.currentSubmissions});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.proposalsLimitReachedSubtitle(currentSubmissions),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colors.textOnPrimaryLevel1,
      ),
    );
  }
}
