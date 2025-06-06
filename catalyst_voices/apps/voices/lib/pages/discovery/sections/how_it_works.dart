import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const Key('HowItWorks'),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key: const Key('HowItWorksTitle'),
              context.l10n.howItWorks,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            Wrap(
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: HowItWorksItem.values.map((e) => _Item(item: e)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

enum HowItWorksItem {
  collaborate,
  vote,
  follow;

  SvgGenImage get icon => switch (this) {
        HowItWorksItem.collaborate => VoicesAssets.icons.userGroup,
        HowItWorksItem.vote => VoicesAssets.icons.vote,
        HowItWorksItem.follow => VoicesAssets.icons.speakerphone,
      };

  String description(VoicesLocalizations l10n) => switch (this) {
        HowItWorksItem.collaborate => l10n.howItWorksCollaborateDescription,
        HowItWorksItem.vote => l10n.howItWorksVoteDescription,
        HowItWorksItem.follow => l10n.howItWorksFollowDescription,
      };

  String title(VoicesLocalizations l10n) => switch (this) {
        HowItWorksItem.collaborate => l10n.howItWorksCollaborate,
        HowItWorksItem.vote => l10n.howItWorksVote,
        HowItWorksItem.follow => l10n.howItWorksFollow,
      };
}

class _Item extends StatelessWidget {
  final HowItWorksItem item;

  const _Item({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VoicesAvatar(
            key: Key('${item.name}Avatar'),
            icon: item.icon.buildIcon(size: 60),
            radius: 60,
            backgroundColor: Theme.of(context).colors.onSurfacePrimary08,
          ),
          const SizedBox(height: 32),
          Text(
            key: Key('${item.name}Title'),
            item.title(context.l10n),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              key: Key('${item.name}Description'),
              item.description(context.l10n),
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 3,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
