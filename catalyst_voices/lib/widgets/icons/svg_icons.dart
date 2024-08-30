import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class NodeIcon extends StatelessWidget {
  final bool isOpen;

  const NodeIcon({
    super.key,
    this.isOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? VoicesAssets.images.nodeOpen.buildIcon()
        : VoicesAssets.images.nodeClosed.buildIcon();
  }
}
