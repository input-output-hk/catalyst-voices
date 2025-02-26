import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignManagementDialog extends StatefulWidget {
  final CampaignPublish? initialValue;
  const CampaignManagementDialog._(this.initialValue);

  static Future<CampaignPublish?> show(
    BuildContext context,
    CampaignPublish? initialValue,
  ) async {
    final result = await VoicesDialog.show<CampaignPublish?>(
      context: context,
      routeSettings: const RouteSettings(name: '/campaign-management'),
      builder: (context) => CampaignManagementDialog._(initialValue),
    );

    return result;
  }

  @override
  State<StatefulWidget> createState() => _CampaignManagementDialogState();
}

class _CampaignManagementDialogState extends State<CampaignManagementDialog> {
  late CampaignPublish _campaignPublish;

  @override
  void initState() {
    super.initState();
    _campaignPublish = widget.initialValue ?? CampaignPublish.draft;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      constraints: const BoxConstraints(maxWidth: 750, maxHeight: 270),
      backgroundColor: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
      header: VoicesAlignTitleHeader(
        title: context.l10n.campaignManagement,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.status,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _CampaignPublishSegmentButton(
              value: _campaignPublish,
              onChanged: (value) => _campaignPublish = value,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: VoicesFilledButton(
                child: Text(context.l10n.saveButtonText),
                onTap: () {
                  Navigator.of(context).pop(_campaignPublish);
                  context
                      .read<CampaignBuilderCubit>()
                      .updateCampaignPublish(_campaignPublish);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignPublishSegmentButton extends StatefulWidget {
  final CampaignPublish value;
  final ValueChanged<CampaignPublish> onChanged;

  const _CampaignPublishSegmentButton({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_CampaignPublishSegmentButton> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<_CampaignPublishSegmentButton> {
  late CampaignPublish _segmentValue;

  @override
  void initState() {
    super.initState();
    _segmentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesSegmentedButton<CampaignPublish>(
      showSelectedIcon: false,
      segments: <ButtonSegment<CampaignPublish>>[
        ButtonSegment<CampaignPublish>(
          value: CampaignPublish.draft,
          label: Text(context.l10n.draft),
        ),
        ButtonSegment<CampaignPublish>(
          value: CampaignPublish.published,
          label: Text(context.l10n.published),
        ),
      ],
      selected: <CampaignPublish>{_segmentValue},
      onChanged: (Set<CampaignPublish> newSelection) {
        setState(() {
          _segmentValue = newSelection.first;
        });
        widget.onChanged(_segmentValue);
      },
    );
  }
}
