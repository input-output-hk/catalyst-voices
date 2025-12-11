import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/proposal_publish_ext.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_builder_delete_confirmation_dialog.dart';
import 'package:catalyst_voices/widgets/text/proposal_version_info_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalIterationHistory extends StatefulWidget {
  final UsersProposalOverview proposal;

  const ProposalIterationHistory({
    super.key,
    required this.proposal,
  });

  @override
  State<ProposalIterationHistory> createState() => _ProposalIterationHistoryState();
}

class _Actions extends StatelessWidget {
  final DocumentRef ref;

  const _Actions({
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesTextButton(
          child: Text(context.l10n.delete),
          onTap: () async => _deleteProposal(context),
        ),
        VoicesTextButton(
          child: Text(context.l10n.exportButtonText),
          onTap: () => _exportProposal(context),
        ),
        VoicesTextButton(
          child: Text(context.l10n.open),
          onTap: () => _editProposal(context),
        ),
      ],
    );
  }

  Future<void> _deleteProposal(BuildContext context) async {
    if (ref is DraftRef) {
      final confirmed = await ProposalBuilderDeleteConfirmationDialog.show(
        context,
        routeSettings: const RouteSettings(
          name: '/proposal_builder/delete-confirmation',
        ),
      );

      if (confirmed && context.mounted) {
        context.read<WorkspaceBloc>().add(DeleteDraftProposalEvent(ref: ref as DraftRef));
      }
    }
  }

  void _editProposal(BuildContext context) {
    unawaited(
      ProposalBuilderRoute.fromRef(ref: ref).push(context),
    );
  }

  void _exportProposal(BuildContext context) {
    final prefix = context.l10n.proposal.toLowerCase();
    context.read<WorkspaceBloc>().add(ExportProposal(ref, prefix));
  }
}

class _IterationVersion extends StatelessWidget {
  final ProposalVersionViewModel version;

  const _IterationVersion({
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.outlineBorderVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(6),
      child: _Title(
        title: version.title,
        iteration: version.versionNumber,
        publish: version.publish,
        updateDate: version.createdAt,
      ),
    );
  }
}

class _IterationVersionList extends StatelessWidget {
  final bool _isExpanded;
  final List<ProposalVersionViewModel> versions;

  const _IterationVersionList({
    required bool isExpanded,
    required this.versions,
  }) : _isExpanded = isExpanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: AnimatedSwitcher(
        duration: Durations.long4,
        child: _isExpanded
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 6,
                children: versions
                    .map(
                      (e) => _IterationVersion(
                        version: e,
                      ),
                    )
                    .toList(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _ProposalIterationHistoryState extends State<ProposalIterationHistory> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeExpanded,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  if (_isExpanded)
                    VoicesAssets.icons.chevronDown.buildIcon(size: 18)
                  else
                    VoicesAssets.icons.chevronRight.buildIcon(size: 18),
                  const SizedBox(width: 4),
                  if (widget.proposal.hasNewerLocalIteration)
                    _Title(
                      publish: widget.proposal.versions.first.publish,
                      title: widget.proposal.versions.first.title,
                      iteration: widget.proposal.versions.first.versionNumber,
                      updateDate: widget.proposal.versions.first.createdAt,
                      boldTitle: true,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        context.l10n.publishingHistory,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.colors.textOnPrimaryLevel1,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Offstage(
                    offstage: !widget.proposal.hasNewerLocalIteration,
                    child: _Actions(
                      ref: widget.proposal.versions.first.id,
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded) const SizedBox(height: 12),
            _IterationVersionList(
              isExpanded: _isExpanded,
              versions: widget.proposal.versions,
            ),
            if (_isExpanded) const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _changeExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

class _Title extends StatelessWidget {
  final String title;
  final int iteration;
  final DateTime updateDate;
  final ProposalPublish publish;
  final bool boldTitle;

  const _Title({
    required this.title,
    required this.iteration,
    required this.updateDate,
    required this.publish,
    this.boldTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final publishName = publish.localizedWorkspaceName(context.l10n);
    return AffixDecorator(
      prefix: VoicesAssets.icons.documentText.buildIcon(size: 18),
      child: ProposalVersionInfoText(
        iteration: iteration,
        publish: publishName,
        updateDate: updateDate,
        title: title,
        boldTitle: boldTitle,
      ),
    );
  }
}
