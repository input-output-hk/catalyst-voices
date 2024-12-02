import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignManagementDialog extends StatefulWidget {
  final CampaignStatus? initialValue;
  const CampaignManagementDialog._(this.initialValue);

  static Future<CampaignStatus?> show(
    BuildContext context,
    CampaignStatus? initialValue,
  ) async {
    final result = await VoicesDialog.show<CampaignStatus?>(
      context: context,
      builder: (context) => CampaignManagementDialog._(initialValue),
    );

    return result;
  }

  @override
  State<StatefulWidget> createState() => _CampaignManagementDialogState();
}

class _CampaignManagementDialogState extends State<CampaignManagementDialog> {
  late CampaignStatus _campaignSetup;

  @override
  void initState() {
    super.initState();
    _campaignSetup = widget.initialValue ?? CampaignStatus.draft;
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
            _CampaignStatusSegmentButton(
              value: _campaignSetup,
              onChanged: (value) => _campaignSetup = value,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: VoicesFilledButton(
                child: Text(context.l10n.saveButtonText),
                onTap: () {
                  Navigator.of(context).pop(_campaignSetup);
                  context
                      .read<CampaignStatusCubit>()
                      .updateCampaignStatus(_campaignSetup);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignStatusSegmentButton extends StatefulWidget {
  final CampaignStatus value;
  final ValueChanged<CampaignStatus> onChanged;

  const _CampaignStatusSegmentButton({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_CampaignStatusSegmentButton> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<_CampaignStatusSegmentButton> {
  late CampaignStatus segmentValue;

  @override
  void initState() {
    super.initState();
    segmentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesSegmentedButton<CampaignStatus>(
      showSelectedIcon: false,
      segments: <ButtonSegment<CampaignStatus>>[
        ButtonSegment<CampaignStatus>(
          value: CampaignStatus.draft,
          label: Text(context.l10n.campaignDraftStatus),
        ),
        ButtonSegment<CampaignStatus>(
          value: CampaignStatus.published,
          label: Text(context.l10n.campaignPublishedStatus),
        ),
      ],
      selected: <CampaignStatus>{segmentValue},
      onChanged: (Set<CampaignStatus> newSelection) {
        setState(() {
          segmentValue = newSelection.first;
        });
        widget.onChanged(segmentValue);
      },
    );
  }
}
