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
import 'package:flutter/material.dart';

class ProposalIterationHistory extends StatefulWidget {
  final Proposal proposal;

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
  final ProposalVersion version;
  final int iteration;

  const _IterationVersion({
    required this.version,
    required this.iteration,
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
        iteration: iteration,
        publish: version.publish,
        updateDate: version.createdAt,
      ),
    );
  }
}

class _IterationVersionList extends StatelessWidget {
  final bool _isExpanded;
  final List<ProposalVersion> versions;

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
                        iteration: versions.versionNumber(
                          e.selfRef.version ?? '',
                        ),
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
  late bool _hasNewerLocalIteration;
  ProposalVersion? _firstVersion;

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
                  if (_hasNewerLocalIteration && _firstVersion != null)
                    _Title(
                      publish: _firstVersion!.publish,
                      title: _firstVersion!.title,
                      iteration: widget.proposal.versions.versionNumber(
                        _firstVersion!.selfRef.version ?? '',
                      ),
                      updateDate: _firstVersion!.createdAt,
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
                  if (_hasNewerLocalIteration && _firstVersion != null)
                    _Actions(
                      ref: _firstVersion!.selfRef,
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

  @override
  void didUpdateWidget(ProposalIterationHistory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.proposal != oldWidget.proposal) {
      _updateState();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  void _changeExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateState() {
    _hasNewerLocalIteration = widget.proposal.hasNewerLocalIteration;
    _firstVersion = widget.proposal.versions.isNotEmpty ? widget.proposal.versions.first : null;
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
