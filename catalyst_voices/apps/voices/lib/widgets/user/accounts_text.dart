import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices/widgets/user/username_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountsText extends StatelessWidget {
  final List<CatalystId> ids;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const AccountsText({
    super.key,
    required this.ids,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final firstId = ids.firstOrNull;
    final isAnonymous = firstId?.isAnonymous ?? false;
    final displayName = firstId?.getDisplayName(context) ?? '';

    return Text.rich(
      TextSpan(
        text: displayName,
        style: TextStyle(fontStyle: isAnonymous ? FontStyle.italic : FontStyle.normal),
        children: [
          if (ids.length > 1) ...[
            TextSpan(text: ' ${context.l10n.andSign} '),
            WidgetSpan(
              child: Tooltip(
                richMessage: WidgetSpan(child: _OtherTooltipOverlay(ids.sublist(1))),
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(),
                constraints: const BoxConstraints(maxWidth: 268),
                enableTapToDismiss: false,
                child: Text(
                  context.l10n.others(ids.length - 1),
                  style: (style ?? const TextStyle()).copyWith(
                    color: Theme.of(context).linksPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class _OtherTooltipOverlay extends StatelessWidget {
  final List<CatalystId> ids;

  const _OtherTooltipOverlay(this.ids);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.elevationsOnSurfaceNeutralLv1White,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ids.map(_OtherTooltipOverlayTile.new).toList(),
      ),
    );
  }
}

class _OtherTooltipOverlayTile extends StatelessWidget {
  final CatalystId id;

  const _OtherTooltipOverlayTile(this.id);

  @override
  Widget build(BuildContext context) {
    final idStyle = context.textTheme.labelSmall;
    final usernameStyle = (context.textTheme.bodyLarge ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ).add(const EdgeInsets.only(right: 8)),
      child: AffixDecorator(
        suffix: CatalystIdText(
          id,
          isCompact: true,
          showCopy: false,
          copyEnabled: false,
          tooltipEnabled: false,
          style: idStyle,
        ),
        child: UsernameText(id.username, style: usernameStyle, maxLines: 1),
      ),
    );
  }
}
