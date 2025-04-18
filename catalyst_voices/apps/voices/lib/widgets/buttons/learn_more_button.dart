import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class LearnMoreButton extends StatelessWidget with LaunchUrlMixin {
  final String learnMoreUrl;

  const LearnMoreButton({
    super.key,
    required this.learnMoreUrl,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      trailing: VoicesAssets.icons.externalLink.buildIcon(),
      onTap: () async {
        await launchUri(learnMoreUrl.getUri());
      },
      child: Text(context.l10n.learnMore),
    );
  }
}
