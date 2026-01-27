import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_category_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentSectionTile extends StatelessWidget {
  final DocumentProperty property;

  const DocumentSectionTile({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitleText(property.schema.title),
          const SizedBox(height: 16),
          DocumentPropertyReadBuilder(
            property: property,
            overrides: {
              ProposalDocument.categoryDetailsNameNodeId: (_, __) => const ProposalCategoryText(),
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitleText extends StatelessWidget {
  final String data;

  const _SectionTitleText(
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.titleMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
