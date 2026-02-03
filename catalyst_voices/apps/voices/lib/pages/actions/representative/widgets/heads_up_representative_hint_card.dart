import 'package:catalyst_voices/common/ext/preferences_ext.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_hint_card.dart';
import 'package:catalyst_voices/widgets/list/bullet_list.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class HeadsUpRepresentativeHintCard extends StatelessWidget {
  const HeadsUpRepresentativeHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionsHintCard(
      constraints: const BoxConstraints.tightFor(height: 134),
      title: context.l10n.headsUpRepresentativeHintTitle,
      icon: VoicesAssets.images.svg.roleDrep.buildIcon(
        allowColorFilter: false,
        size: 60,
      ),
      iconPadding: EdgeInsets.zero,
      iconBackgroundColor: Colors.transparent,
      description: const _HintSteps(),
    );
  }
}

class _HintSteps extends StatelessWidget {
  const _HintSteps();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RepresentativeActionCubit, RepresentativeActionState, DateTime?>(
      selector: (state) {
        return state.votingSnapshotDate;
      },
      builder: (context, votingSnapshotDate) {
        return BulletList(
          key: const Key('InfoCardDesc'),
          items: [
            context.l10n.headsUpRepresentativeHintContent1,
            _getRepresentativeHintTextWithDate(context, votingSnapshotDate),
          ],
          spacing: 0,
        );
      },
    );
  }

  String _getRepresentativeHintTextWithDate(
    BuildContext context,
    DateTime? votingSnapshotDate,
  ) {
    if (votingSnapshotDate == null) {
      return context.l10n.headsUpRepresentativeHintContent2(
        context.l10n.votingTimelineToBeAnnounced,
      );
    }

    final timezone = context.select<SessionCubit?, TimezonePreferences>(
      (cubit) => cubit?.state.settings.timezone ?? TimezonePreferences.local,
    );

    final effectiveDate = timezone.applyTo(votingSnapshotDate);
    final formattedDate = DateFormatter.formatFullDate24Format(effectiveDate);
    final timezoneLabel = timezone.localizedName(context);

    final dateWithTimezone = '$formattedDate $timezoneLabel';

    return context.l10n.headsUpRepresentativeHintContent2(dateWithTimezone);
  }
}
