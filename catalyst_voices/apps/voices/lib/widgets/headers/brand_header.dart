import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class BrandHeader extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const BrandHeader({
    super.key,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Theme.of(context).brandAssets.brand.logo(context).buildPicture(),
          IconButton(
            key: const ValueKey('MenuCloseButton'),
            onPressed: Navigator.of(context).pop,
            icon: VoicesAssets.icons.x.buildIcon(size: 22),
          ),
        ],
      ),
    );
  }
}
