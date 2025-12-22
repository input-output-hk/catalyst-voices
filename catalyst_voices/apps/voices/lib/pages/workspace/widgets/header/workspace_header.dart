import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/pages/workspace/widgets/header/invitations_approvals_button.dart';
import 'package:catalyst_voices/pages/workspace/widgets/header/workspace_timeline.dart';
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        const CreateProposalButton(showTrailingIcon: true),
        const InvitationsApprovalsButton(),
        const _ImportProposalButton(),
        _TimelineToggleButton(
          onPressed: onTap,
        ),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      Space.workspace.localizedName(context.l10n),
      style: context.textTheme.headlineLarge?.copyWith(
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _WorkspaceHeaderState extends State<WorkspaceHeader> {
  bool _isTimelineVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsivePadding(
      sm: const EdgeInsets.symmetric(horizontal: 12),
      md: const EdgeInsets.symmetric(horizontal: 32),
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
                const _HeaderText(),
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
