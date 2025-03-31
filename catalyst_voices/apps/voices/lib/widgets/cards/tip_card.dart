import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

class TipCard extends StatelessWidget {
  final String headerText;
  final List<String> tips;

  const TipCard({
    super.key,
    required this.headerText,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.colors.onSurfaceNeutralOpaqueLv1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: context.colorScheme.primary,
            ),
            child: VoicesAssets.icons.lightBulb.buildIcon(
              size: 38,
              color: context.colors.iconsBackground,
            ),
          ),
          SizedBox(
            width: 268,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  headerText,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colors.textOnPrimaryLevel1,
                  ),
                ),
                for (final tip in tips)
                  Text(
                    tip.bullet(),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.textOnPrimaryLevel1,
                    ),
                  ),
              ],
            ),
          ),
          VoicesAvatar(
            foregroundColor: context.colors.iconsPrimary,
            backgroundColor: context.colors.iconsBackground,
            icon: VoicesAssets.icons.informationCircle.buildIcon(),
          ),
        ],
      ),
    );
  }
}
