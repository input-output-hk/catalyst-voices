import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class DocumentTagChip extends StatelessWidget {
  final String name;

  const DocumentTagChip({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      leading: VoicesAssets.icons.tag.buildIcon(),
      content: Text(name),
    );
  }
}
