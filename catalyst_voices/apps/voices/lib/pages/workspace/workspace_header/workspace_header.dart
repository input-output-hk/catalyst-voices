import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
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

class WorkspaceHeader extends StatelessWidget {
  const WorkspaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            ProjectText(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(),
                Spacer(),
                CreateProposalButton(),
                SizedBox(width: 8),
                ImportProposalButton(),
                SizedBox(width: 8),
                TimelineToggleButton(),
              ],
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleText(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SearchTextField(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            WorkspaceTabSelector(),
          ],
        ),
      ),
    );
  }
}
