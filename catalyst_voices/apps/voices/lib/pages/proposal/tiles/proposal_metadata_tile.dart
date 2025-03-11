import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_delivery_card.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_version.dart';
import 'package:catalyst_voices/widgets/common/proposal_status_container.dart';
import 'package:catalyst_voices/widgets/document/document_comments_chip.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    hide ProposalVersion;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalMetadataTile extends StatelessWidget {
  final Profile author;
  final String? description;
  final ProposalStatus status;
  final DateTime createdAt;
  final String? tag;
  final int commentsCount;
  final int fundsRequested;
  final int projectDuration;
  final int milestoneCount;

  const ProposalMetadataTile({
    super.key,
    required this.author,
    this.description,
    required this.status,
    required this.createdAt,
    this.tag,
    required this.commentsCount,
    required this.fundsRequested,
    required this.projectDuration,
    required this.milestoneCount,
  });

  @override
  Widget build(BuildContext context) {
    final description = this.description;
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
            ProposalStatusContainer(type: status),
            const SizedBox(width: 8),
            const ProposalVersion(readOnly: true),
            const SizedBox(width: 16),
            TimestampText(createdAt),
            if (tag != null) ...[
              const SizedBox(width: 16),
              DocumentTagChip(name: tag),
            ],
            const SizedBox(width: 8),
            DocumentCommentsChip(count: commentsCount),
          ],
        ),
        if (description != null)
          Text(
            description,
            style: context.textTheme.bodyLarge
                ?.copyWith(color: context.colors.textOnPrimaryLevel0),
          ),
        ProposalDeliveryCard(
          fundsRequested: fundsRequested,
          projectDuration: projectDuration,
          milestoneCount: milestoneCount,
        ),
      ].separatedBy(const SizedBox(height: 16)).toList(),
    );
  }
}
