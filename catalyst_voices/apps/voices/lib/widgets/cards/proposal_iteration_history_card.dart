import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/proposal_publish_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalIterationHistory extends StatefulWidget {
  final ProposalWithVersions proposal;

  const ProposalIterationHistory({
    super.key,
    required this.proposal,
  });

  @override
  State<ProposalIterationHistory> createState() =>
      _ProposalIterationHistoryState();
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
        updateDate: version.updateDate,
      ),
    );
  }
}

class _ProposalIterationHistoryState extends State<ProposalIterationHistory> {
  bool _isExpanded = false;
  bool get _hasNewerLocalIteration =>
      widget.proposal.versions.first.isLatestVersion(
        widget.proposal.selfRef.version ?? '',
      );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
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
                horizontal: 17,
              ),
              child: Row(
                children: [
                  if (_isExpanded)
                    VoicesAssets.icons.chevronDown.buildIcon(size: 18)
                  else
                    VoicesAssets.icons.chevronRight.buildIcon(size: 18),
                  const SizedBox(width: 4),
                  if (_hasNewerLocalIteration)
                    _Title(
                      publish: widget.proposal.versions.first.publish,
                      title: widget.proposal.versions.first.title,
                      iteration: widget.proposal.versions.versionNumber(
                        widget.proposal.versions.first.selfRef.version ?? '',
                      ),
                      updateDate: widget.proposal.versions.first.updateDate,
                      boldTitle: true,
                    )
                  else
                    Text(
                      context.l10n.publishingHistory,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colors.textOnPrimaryLevel1,
                      ),
                    ),
                  const Spacer(),
                  Offstage(
                    offstage: !_hasNewerLocalIteration,
                    child: Row(
                      children: [
                        VoicesTextButton(
                          child: Text(context.l10n.delete),
                          onTap: () {
                            // TODO(dtscalac): call delete method
                          },
                        ),
                        VoicesTextButton(
                          child: Text(context.l10n.exportButtonText),
                          onTap: () {
                            // TODO(dtscalac): call export method
                          },
                        ),
                        VoicesTextButton(
                          child: Text(context.l10n.open),
                          onTap: () {
                            // TODO(dtscalac): call open method
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded) const SizedBox(height: 12),
            Padding(
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
                        children: widget.proposal.versions
                            .skip(1)
                            .map(
                              (e) => _IterationVersion(
                                version: e,
                                iteration:
                                    widget.proposal.versions.versionNumber(
                                  e.selfRef.version ?? '',
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            if (_isExpanded) const SizedBox(height: 16),
          ],
        ),
      ),
    );
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
    final datetime = DateFormatter.formatDayMonthTime(updateDate);
    final publishName = publish.localizedWorkspaceName(context.l10n);
    return AffixDecorator(
      prefix: VoicesAssets.icons.documentText.buildIcon(size: 18),
      child: Text(
        context.l10n.proposalIterationPublishUpdateAndTitle(
          iteration,
          publishName,
          datetime,
          title,
        ),
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
          fontWeight: boldTitle ? FontWeight.bold : FontWeight.w100,
        ),
      ),
    );
  }
}
