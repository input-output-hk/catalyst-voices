import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_version.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalNavigationControls extends StatelessWidget {
  final VoidCallback onToggleTap;
  final bool isCompact;

  const ProposalNavigationControls({
    super.key,
    required this.onToggleTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        const _BackButton(),
        const SizedBox(height: 20),
        Row(
          children: [
            _ToggleRailButton(onTap: onToggleTap),
            const Spacer(),
            const ProposalVersion(showBorder: false),
          ],
        ),
        const SizedBox(height: 12),
        const _Divider(),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return NavigationBack(
      label: context.l10n.backToList,
      padding: const EdgeInsets.all(8),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return VoicesDivider.expanded(
      height: 1,
      color: context.colors.outlineBorderVariant,
    );
  }
}

class _ToggleRailButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ToggleRailButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.leftRailToggle.buildIcon(),
    );
  }
}
