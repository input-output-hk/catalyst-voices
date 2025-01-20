import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum HowItWorksItem {
  collaborate,
  vote,
  follow;

  SvgGenImage get icon => switch (this) {
        HowItWorksItem.collaborate => VoicesAssets.icons.userGroup,
        HowItWorksItem.vote => VoicesAssets.icons.vote,
        HowItWorksItem.follow => VoicesAssets.icons.speakerphone,
      };

  String title(VoicesLocalizations l10n) => switch (this) {
        HowItWorksItem.collaborate => l10n.howItWorksCollaborate,
        HowItWorksItem.vote => l10n.howItWorksVote,
        HowItWorksItem.follow => l10n.howItWorksFollow,
      };

  String description(VoicesLocalizations l10n) => switch (this) {
        HowItWorksItem.collaborate => l10n.howItWorksCollaborateDescription,
        HowItWorksItem.vote => l10n.howItWorksVoteDescription,
        HowItWorksItem.follow => l10n.howItWorksFollowDescription,
      };
}

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1440 / 532,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.howItWorks,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            Wrap(
              direction: Axis.horizontal,
              children:
                  HowItWorksItem.values.map((e) => _Item(item: e)).toList(),
            ),
          ],
        ),
      ),
    );
  }
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
            icon: item.icon.buildIcon(size: 60),
            radius: 60,
            backgroundColor: Theme.of(context).colors.onSurfacePrimary08,
          ),
          const SizedBox(height: 32),
          Text(
            item.title(context.l10n),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
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
