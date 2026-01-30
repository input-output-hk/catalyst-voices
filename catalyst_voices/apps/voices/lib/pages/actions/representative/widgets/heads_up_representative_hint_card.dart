import 'package:catalyst_voices/pages/actions/widgets/actions_hint_card.dart';
import 'package:catalyst_voices/widgets/list/bullet_list.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
      description: BulletList(
        key: const Key('InfoCardDesc'),
        items: [
          context.l10n.headsUpRepresentativeHintContent1,
          _getRepresentativeHintTextWithDate(context),
        ],
        spacing: 0,
      ),
    );
  }

  String _getRepresentativeHintTextWithDate(BuildContext context) {
    // TODO(LynxLynxx): add logic to get the date and format it with time zone settings
    return context.l10n.headsUpRepresentativeHintContent2(context.l10n.votingTimelineToBeAnnounced);
  }
}
