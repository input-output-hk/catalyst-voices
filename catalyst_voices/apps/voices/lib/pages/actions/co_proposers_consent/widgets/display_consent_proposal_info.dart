import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class DisplayConsentProposalInfo extends StatelessWidget {
  final String categoryName;
  final String proposalTitle;

  const DisplayConsentProposalInfo({
    super.key,
    required this.categoryName,
    required this.proposalTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          categoryName,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        Text(
          proposalTitle,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colors.textOnPrimaryLevel0,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
