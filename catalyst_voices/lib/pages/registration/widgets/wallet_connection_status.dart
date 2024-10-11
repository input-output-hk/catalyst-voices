import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class WalletConnectionStatus extends StatelessWidget {
  final String? icon;
  final String name;
  final bool isConnected;

  const WalletConnectionStatus({
    super.key,
    required this.icon,
    required this.name,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        VoicesWalletTileIcon(iconSrc: icon),
        const SizedBox(width: 12),
        Text(name, style: Theme.of(context).textTheme.bodyLarge),
        if (isConnected) ...[
          const SizedBox(width: 8),
          VoicesAvatar(
            radius: 10,
            padding: const EdgeInsets.all(4),
            icon: VoicesAssets.icons.check.buildIcon(),
            foregroundColor: Theme.of(context).colors.success,
            backgroundColor: Theme.of(context).colors.successContainer,
          ),
        ],
      ],
    );
  }
}
