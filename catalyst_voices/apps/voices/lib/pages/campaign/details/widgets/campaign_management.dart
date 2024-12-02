import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_management_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignManagement extends StatefulWidget {
  const CampaignManagement({super.key});

  @override
  State<CampaignManagement> createState() => _CampaignManagementState();
}

class _CampaignManagementState extends State<CampaignManagement> {
  @override
  void initState() {
    super.initState();
    context.read<CampaignStatusCubit>().getCampaignStatus();
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = context.watch<CampaignStatusCubit>().campaignStatus;
    return Row(
      children: [
        VoicesOutlinedButton(
          child: Text(context.l10n.campaignManagement),
          onTap: () async {
            final result =
                await CampaignManagementDialog.show(context, currentStatus);
            _handleDialogResult(result);
          },
        ),
        _CampaignStatusIndicator(
          campaignStatus: CampaignStatus.draft,
          currentStatus: currentStatus,
        ),
        _CampaignStatusIndicator(
          campaignStatus: CampaignStatus.published,
          currentStatus: currentStatus,
        ),
      ],
    );
  }

  void _handleDialogResult(CampaignStatus? newStatus) {
    if (newStatus == null) return;

    context.read<CampaignStatusCubit>().updateCampaignStatus(newStatus);
  }
}

class _CampaignStatusIndicator extends StatelessWidget {
  final CampaignStatus campaignStatus;
  final CampaignStatus? currentStatus;

  const _CampaignStatusIndicator({
    required this.campaignStatus,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: currentStatus == campaignStatus
              ? theme.colors.success
              : theme.colors.onSurfaceNeutral012?.withOpacity(.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Row(
            children: [
              VoicesAssets.icons.check.buildIcon(
                color: currentStatus == campaignStatus
                    ? theme.colors.successContainer
                    : theme.colors.onSurfaceNeutral012,
              ),
              const SizedBox(width: 8),
              switch (campaignStatus) {
                CampaignStatus.draft => _Text(
                    context.l10n.campaignDraftStatus,
                    isSelected: campaignStatus.isSelected(currentStatus),
                  ),
                CampaignStatus.published => _Text(
                    context.l10n.campaignPublishedStatus,
                    isSelected: campaignStatus.isSelected(currentStatus),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _Text(
    this.text, {
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected
                ? theme.colors.successContainer
                : theme.colors.onSurfaceNeutral012,
          ),
    );
  }
}
