import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SeedPhraseViewer extends StatelessWidget {
  final int number;
  final String word;

  const SeedPhraseViewer({
    super.key,
    required this.number,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        color: theme.colors.onSurfaceNeutralOpaqueLv1,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyLarge ?? const TextStyle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${number.toString().padLeft(2, '0')}.',
              style: TextStyle(color: theme.colors.textOnPrimary),
            ),
            const SizedBox(width: 6),
            Text(
              word,
              style: TextStyle(color: theme.colors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
