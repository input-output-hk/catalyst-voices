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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 250) {
          return _CompactControls(onToggleTap: onToggleTap);
        }
        return _StandardControls(onToggleTap: onToggleTap);
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  final bool isCompact;

  const _BackButton({
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBack(
      label: context.l10n.backToList,
      isCompact: isCompact,
    );
  }
}

class _CompactControls extends StatelessWidget {
  final VoidCallback onToggleTap;

  const _CompactControls({
    required this.onToggleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 56),
        const _BackButton(isCompact: true),
        _ToggleRailButton(onTap: onToggleTap),
      ],
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

class _StandardControls extends StatelessWidget {
  final VoidCallback onToggleTap;

  const _StandardControls({
    required this.onToggleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const _BackButton(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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

class _ToggleRailButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ToggleRailButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      style: IconButton.styleFrom(
        foregroundColor: context.colors.textOnPrimaryLevel1,
      ),
      child: VoicesAssets.icons.leftRailToggle.buildIcon(),
    );
  }
}
