import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class DocumentSegmentTitle extends StatelessWidget {
  final String title;

  const DocumentSegmentTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
