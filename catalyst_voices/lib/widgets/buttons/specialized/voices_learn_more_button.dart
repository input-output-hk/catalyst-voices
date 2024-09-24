import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A "Learn More" button that redirects usually to an external content.
class VoicesLearnMoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoicesLearnMoreButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      trailing: VoicesAssets.icons.externalLink.buildIcon(),
      onTap: onTap,
      child: Text(context.l10n.learnMore),
    );
  }
}
