import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String text;
  final String? username;
  final DateTime date;

  const CommentCard({
    super.key,
    required this.text,
    required this.username,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: .38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VoicesAssets.icons.chatAlt.buildIcon(),
            const SizedBox(height: 10),
            Text(text),
            const SizedBox(height: 10),
            Row(
              children: [
                VoicesAvatar(icon: VoicesAssets.icons.user.buildIcon()),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UsernameText(username),
                    Text(date.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
