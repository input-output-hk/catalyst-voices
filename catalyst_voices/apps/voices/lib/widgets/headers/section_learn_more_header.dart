import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class SectionLearnMoreHeader extends StatelessWidget with LaunchUrlMixin {
  final String title;
  final String info;
  final String learnMoreUrl;
  const SectionLearnMoreHeader({
    super.key,
    required this.title,
    required this.info,
    required this.learnMoreUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(width: 4),
        VoicesPlainTooltip(
          message: context.l10n.learnMore,
          child: VoicesAssets.icons.informationCircle.buildIcon(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const Spacer(),
        VoicesTextButton(
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          onTap: () async {
            await launchUri(learnMoreUrl.getUri());
          },
          child: Text(context.l10n.learnMore),
        ),
      ],
    );
  }
}
