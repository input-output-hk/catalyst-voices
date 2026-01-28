import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/images/voices_image_scheme.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class ProposalApprovalEmptyState extends StatelessWidget {
  final String title;
  final String description;

  const ProposalApprovalEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      key: const Key('ProposalApprovalEmpty'),
      title: Text(title),
      description: Text(description),
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
    );
  }
}
