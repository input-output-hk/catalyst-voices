import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/images/voices_image_scheme.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalsPaginationEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const ProposalsPaginationEmptyState({
    super.key,
    required this.hasSearchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasSearchQuery)
          Text(
            context.l10n.searchResult,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        EmptyState(
          key: const Key('EmptyProposals'),
          title: hasSearchQuery ? Text(context.l10n.emptySearchResultTitle) : null,
          description: hasSearchQuery
              ? Text(context.l10n.tryDifferentSearch)
              : Text(context.l10n.discoverySpaceEmptyProposals),
          image: VoicesImagesScheme(
            image: VoicesAssets.images.svg.noProposalForeground.buildPicture(),
            background: Container(
              height: 180,
              decoration: BoxDecoration(
                color: context.colors.onSurfaceNeutral08,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
