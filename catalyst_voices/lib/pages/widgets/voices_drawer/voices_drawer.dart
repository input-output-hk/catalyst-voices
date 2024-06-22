import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

// TODO(dtscalac): docs
class VoicesDrawer extends StatelessWidget {
  final List<Widget> children;

  const VoicesDrawer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        dividerTheme: theme.dividerTheme.copyWith(
          indent: 24,
          endIndent: 24,
          space: 16,
        ),
      ),
      child: Drawer(
        shape: const RoundedRectangleBorder(),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const _Header(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CatalystSvgPicture.asset(
            Theme.of(context).brandAssets.logo.path,
          ),
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
