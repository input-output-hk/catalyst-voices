import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_proposal_button.dart';
part 'import_proposal_button.dart';
part 'project_text.dart';
part 'search_text_field.dart';
part 'sub_title_text.dart';
part 'timeline_toggle_button.dart';
part 'title_text.dart';
part 'workspace_tab_selector.dart';
part 'workspace_tabs.dart';

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
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const ProjectText(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(),
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
            // const Row(
            //   mainAxisSize: MainAxisSize.max,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Expanded(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           SubTitleText(),
            //           SizedBox(height: 16),
            //         ],
            //       ),
            //     ),
            //     SizedBox(width: 20),
            //     Expanded(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           SearchTextField(),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // const WorkspaceTabSelector(),
          ],
        ),
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
