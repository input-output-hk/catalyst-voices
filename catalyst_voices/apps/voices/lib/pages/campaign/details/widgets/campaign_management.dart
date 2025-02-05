import 'dart:async';

import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_management_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
    context.read<CampaignBuilderCubit>().getCampaignStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignBuilderCubit, CampaignBuilderState,
        CampaignPublish?>(
      selector: (state) => state.publish,
      builder: (context, publish) {
        return Row(
          children: [
            VoicesOutlinedButton(
              child: Text(context.l10n.campaignManagement),
              onTap: () => unawaited(_showManagementDialog(publish)),
            ),
            _CampaignStatusIndicator(
              campaignStatus: CampaignPublish.draft,
              currentStatus: publish,
            ),
            _CampaignStatusIndicator(
              campaignStatus: CampaignPublish.published,
              currentStatus: publish,
            ),
          ],
        );
      },
    );
  }

  Future<void> _showManagementDialog(CampaignPublish? publish) async {
    final result = await CampaignManagementDialog.show(context, publish);
    if (mounted) {
      _handleDialogResult(result);
    }
  }

  void _handleDialogResult(CampaignPublish? newPublish) {
    if (newPublish == null) return;
    context.read<CampaignBuilderCubit>().updateCampaignPublish(newPublish);
  }
}

class _CampaignStatusIndicator extends StatelessWidget {
  final CampaignPublish campaignStatus;
  final CampaignPublish? currentStatus;

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
              : theme.colors.onSurfaceNeutral012.withOpacity(.12),
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
                CampaignPublish.draft => _Text(
                    context.l10n.draft,
                    isSelected: campaignStatus == currentStatus,
                  ),
                CampaignPublish.published => _Text(
                    context.l10n.published,
                    isSelected: campaignStatus == currentStatus,
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
