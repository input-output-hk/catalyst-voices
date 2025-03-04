import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentCommentsChip extends StatelessWidget {
  final int count;

  const DocumentCommentsChip({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      leading: VoicesAssets.icons.chatAlt2.buildIcon(),
      content: Text(context.l10n.noOfComments(count)),
    );
  }
}
