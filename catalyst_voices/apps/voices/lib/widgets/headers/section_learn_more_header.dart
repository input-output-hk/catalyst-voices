import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/tooltips/voices_markdown_tooltip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class SectionLearnMoreHeader extends StatelessWidget with LaunchUrlMixin {
  final String title;
  final String info;
  final String learnMoreUrl;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  const SectionLearnMoreHeader({
    super.key,
    required this.title,
    required this.info,
    required this.learnMoreUrl,
    this.isExpanded = false,
    this.onExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onExpandedChanged,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
            child: isExpanded
                ? VoicesAssets.icons.chevronDown.buildIcon()
                : VoicesAssets.icons.chevronRight.buildIcon(),
          ),
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(width: 4),
          VoicesMarkdownTooltip(
            message: info,
            constraints: const BoxConstraints(maxWidth: 312),
            child: VoicesAssets.icons.informationCircle.buildIcon(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          const Spacer(),
          VoicesLearnMoreTextButton.url(url: learnMoreUrl),
        ],
      ),
    );
  }

  void _onExpandedChanged() {
    onExpandedChanged?.call(!isExpanded);
  }
}
