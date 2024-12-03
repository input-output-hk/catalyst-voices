import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// The "events" tab of the [CampaignAdminToolsDialog].
class CampaignAdminToolsEventsTab extends StatelessWidget {
  const CampaignAdminToolsEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: _CampaignStatusChooser()),
        _EventTimelapseControls(),
      ],
    );
  }
}

class _CampaignStatusChooser extends StatelessWidget {
  const _CampaignStatusChooser();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          for (final status in CampaignStage.values)
            if (status != CampaignStage.scheduled)
              // TODO(dtscalac): store active one somewhere
              _EventItem(
                status: status,
                isActive: status == CampaignStage.draft,
                onTap: () {},
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final CampaignStage status;
  final bool isActive;
  final VoidCallback onTap;

  const _EventItem({
    required this.status,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colors.textOnPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
        child: Row(
          children: [
            _icon.buildIcon(
              size: 24,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _text(context.l10n),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: color,
                    ),
              ),
            ),
            if (isActive)
              Text(
                context.l10n.active.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: color,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  SvgGenImage get _icon => switch (status) {
        CampaignStage.draft => VoicesAssets.icons.clock,
        CampaignStage.live => VoicesAssets.icons.flag,
        _ => VoicesAssets.icons.calendar,
      };

  String _text(VoicesLocalizations l10n) => switch (status) {
        CampaignStage.draft => l10n.campaignPreviewEventBefore,
        CampaignStage.live => l10n.campaignPreviewEventDuring,
        _ => l10n.campaignPreviewEventAfter,
      };
}

class _EventTimelapseControls extends StatelessWidget {
  const _EventTimelapseControls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: VoicesTextButton(
              leading: VoicesAssets.icons.rewind.buildIcon(),
              child: Text(context.l10n.previous),
              // TODO(dtscalac): implement button action
              onTap: () {},
            ),
          ),
          Container(
            width: 60,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            ),
            alignment: Alignment.center,
            // TODO(dtscalac): implement timer ticking
            child: const Text('-5s'),
          ),
          Expanded(
            child: VoicesTextButton(
              leading: VoicesAssets.icons.fastForward.buildIcon(),
              child: Text(context.l10n.next),
              // TODO(dtscalac): implement button action
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
