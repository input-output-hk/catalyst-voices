import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/pages/workspace/header/workspace_timeline.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' show ProposalDocument, Space;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

part 'import_proposal_button.dart';
part 'timeline_toggle_button.dart';

class WorkspaceHeader extends StatefulWidget {
  const WorkspaceHeader({super.key});

  @override
  State<WorkspaceHeader> createState() => _WorkspaceHeaderState();
}

class _HeaderActions extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderActions({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CreateProposalButton(showTrailingIcon: true),
          const SizedBox(width: 8),
          const _ImportProposalButton(),
          const SizedBox(width: 8),
          _TimelineToggleButton(
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final ThemeData theme;

  const _HeaderText({
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      Space.workspace.localizedName(context.l10n),
      style: theme.textTheme.headlineLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _WorkspaceHeaderState extends State<WorkspaceHeader> {
  bool _isTimelineVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const smallScreenPadding = EdgeInsets.symmetric(horizontal: 12);

    return ResponsivePadding.only(
      xs: smallScreenPadding,
      sm: smallScreenPadding,
      other: const EdgeInsets.symmetric(horizontal: 32),
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
          SizedBox(
            width: double.maxFinite,
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _HeaderText(theme: theme),
                _HeaderActions(onTap: _toggleTimelineVisibility),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_isTimelineVisible) ...[
            const WorkspaceTimeline(),
            const SizedBox(height: 48),
          ],
        ],
      ),
    );
  }

  void _toggleTimelineVisibility() {
    setState(() {
      _isTimelineVisible = !_isTimelineVisible;
    });
  }
}
