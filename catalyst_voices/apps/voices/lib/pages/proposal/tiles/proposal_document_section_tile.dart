import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalDocumentSectionTile extends StatelessWidget {
  final DocumentProperty property;

  const ProposalDocumentSectionTile({
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
          DocumentPropertyReadBuilder(property: property),
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
