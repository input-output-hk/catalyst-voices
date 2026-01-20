import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_version_text.dart';
import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_collaborators.dart';
import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_delivery_card.dart';
import 'package:catalyst_voices/widgets/document/document_comments_chip.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide ProposalVersion;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalMetadataTile extends StatelessWidget {
  final Profile author;
  final Collaborators collaborators;
  final String? description;
  final ProposalPublish status;
  final DateTime? createdAt;
  final bool warningCreatedAt;
  final String? tag;
  final int? commentsCount;
  final Money? fundsRequested;
  final int? projectDuration;
  final int? milestoneCount;

  const ProposalMetadataTile({
    super.key,
    required this.author,
    required this.collaborators,
    this.description,
    required this.status,
    required this.createdAt,
    this.warningCreatedAt = false,
    this.tag,
    required this.commentsCount,
    required this.fundsRequested,
    required this.projectDuration,
    required this.milestoneCount,
  });

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    final createdAt = this.createdAt;
    final tag = this.tag;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileContainer(profile: author),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          children: <Widget>[
            ProposalPublishChip(proposalPublish: status),
            const SizedBox(width: 8),
            DocumentVersionText(readOnly: !CatalystFormFactor.current.isMobile),
            if (createdAt != null) ...[
              const SizedBox(width: 16),
              _CreatedAtText(
                dateTime: createdAt,
                isWarning: warningCreatedAt,
              ),
            ],
            if (tag != null) ...[
              const SizedBox(width: 16),
              DocumentTagChip(name: tag),
            ],
            if (commentsCount case final commentsCount?) ...[
              const SizedBox(width: 8),
              DocumentCommentsChip(count: commentsCount),
            ],
          ],
        ),
        if (description != null)
          Text(
            description,
            style: context.textTheme.bodyLarge?.copyWith(color: context.colors.textOnPrimaryLevel0),
          ),
        if (collaborators.isNotEmpty) ProposalCollaborators(collaborators: collaborators),
        ProposalDeliveryCard(
          fundsRequested: fundsRequested,
          projectDuration: projectDuration,
          milestoneCount: milestoneCount,
        ),
      ].separatedBy(const SizedBox(height: 16)).toList(),
    );
  }
}

class _CreatedAtText extends StatelessWidget {
  final DateTime dateTime;
  final bool isWarning;

  const _CreatedAtText({
    required this.dateTime,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeTextTheme(
      data: TimezoneDateTimeTextThemeData(
        backgroundColor: isWarning ? WidgetStatePropertyAll(context.colors.warningContainer) : null,
        foregroundColor: isWarning ? WidgetStatePropertyAll(context.colors.warning) : null,
      ),
      child: TimestampText(dateTime),
    );
  }
}
