import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class DocumentPropertyBuilderTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  const DocumentPropertyBuilderTitle({
    super.key,
    required this.title,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.starred(isEnabled: isRequired),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colors.textOnPrimaryLevel1,
          ),
    );
  }
}
