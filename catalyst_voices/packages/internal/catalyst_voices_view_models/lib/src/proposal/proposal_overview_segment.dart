import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final class ProposalMetadataSection extends ProposalOverviewSection {
  final ProposalViewMetadata data;

  const ProposalMetadataSection({
    required super.id,
    required this.data,
  });

  @override
  List<Object?> get props => super.props + [data];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewMetadataSection;
  }
}

sealed class ProposalOverviewSection extends BaseSection {
  const ProposalOverviewSection({
    required super.id,
  });
}

final class ProposalOverviewSegment extends BaseSegment<ProposalOverviewSection> {
  final String categoryName;
  final String proposalTitle;

  const ProposalOverviewSegment({
    required super.id,
    required this.categoryName,
    required this.proposalTitle,
    required super.sections,
  });

  ProposalOverviewSegment.build({
    required this.categoryName,
    required this.proposalTitle,
    required ProposalViewMetadata data,
  }) : super(
          id: const NodeId('overview'),
          sections: [
            ProposalMetadataSection(
              id: const NodeId('overview.metadata'),
              data: data,
            ),
          ],
        );

  @override
  SvgGenImage get icon => VoicesAssets.icons.lightningBolt;

  @override
  List<Object?> get props => super.props + [categoryName, proposalTitle];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewMetadataOverviewSegment;
  }
}
