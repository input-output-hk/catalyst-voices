import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'create_proposal_button.dart';
part 'import_proposal_button.dart';
part 'timeline_toggle_button.dart';

class WorkspaceHeader extends StatefulWidget {
  const WorkspaceHeader({super.key});

  @override
  State<WorkspaceHeader> createState() => _WorkspaceHeaderState();
}

class _WorkspaceHeaderState extends State<WorkspaceHeader> {
  bool isTimelineExpanded = false;
  bool isTimelineVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            context.l10n.catalyst,
            style: theme.textTheme.titleSmall?.copyWith(
              color: VoicesColors.lightTextOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Space.workspace.localizedName(context.l10n),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              const CreateProposalButton(),
              const SizedBox(width: 8),
              const ImportProposalButton(),
              const SizedBox(width: 8),
              TimelineToggleButton(
                onPressed: _toggleTimelineVisibility,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isTimelineVisible)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: isTimelineExpanded ? 340 : 190,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withAlpha(51),
                      ),
                    ),
                    child: CampaignTimeline(
                      timelineItems: CampaignTimelineViewModelX.mockData,
                      placement: CampaignTimelinePlacement.workspace,
                      onExpandedChanged: (isExpanded) {
                        setState(() {
                          isTimelineExpanded = isExpanded;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _toggleTimelineVisibility() {
    setState(() {
      isTimelineVisible = !isTimelineVisible;
      if (!isTimelineVisible) {
        isTimelineExpanded = false;
      }
    });
  }
}
