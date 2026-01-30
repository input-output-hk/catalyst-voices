import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/menu/voices_raw_popup_menu.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

// TODO(dt-iohk): design on figma included a wallet address,
// icon and connection status, consider how to add it here.
class AccountVotingRoleTooltip extends StatelessWidget {
  final String title;
  final String message;
  final DateTime? updatedAt;
  final VotingPowerStatus? status;
  final VoidCallback onLearnMore;

  const AccountVotingRoleTooltip({
    super.key,
    required this.title,
    required this.message,
    required this.updatedAt,
    required this.status,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updatedAt = this.updatedAt;
    final status = this.status;

    return VoicesRawPopupMenu(
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 320),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colors.textOnPrimaryLevel1,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colors.outlineBorderVariant,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TooltipItem(
                        label: context.l10n.updated,
                        value: updatedAt != null
                            ? DateFormatter.formatDayMonthTime(updatedAt)
                            : _formatEmpty(),
                      ),
                    ),
                    Expanded(
                      child: _TooltipItem(
                        label: context.l10n.status,
                        value: status != null ? status.localizedName(context) : _formatEmpty(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              VoicesOutlinedButton(
                onTap: () {
                  // close the tooltip before calling a callback
                  Navigator.of(context).pop();
                  onLearnMore();
                },
                child: Text(context.l10n.learnMore),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEmpty() => '---';
}

class _TooltipItem extends StatelessWidget {
  final String label;
  final String value;

  const _TooltipItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.8,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel0,
          ),
        ),
      ],
    );
  }
}
