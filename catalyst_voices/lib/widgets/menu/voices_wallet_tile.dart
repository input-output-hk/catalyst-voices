import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A replacement for the [ListTile] with customized
/// styling that displays a [CardanoWallet].
class VoicesWalletTile extends StatelessWidget {
  /// URI or base64 encoded icon of the wallet extension.
  final String? iconSrc;

  /// The name of the wallet extension.
  final Widget? name;

  /// A callback called when the widget is pressed.
  final VoidCallback? onTap;

  /// The default constructor for the [VoicesWalletTile].
  const VoicesWalletTile({
    super.key,
    this.iconSrc,
    this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = this.iconSrc;
    final name = this.name;

    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: icon == null
            ? _IconPlaceholder()
            : Image.network(
                icon,
                errorBuilder: (context, error, stackTrace) {
                  return _IconPlaceholder();
                },
              ),
      ),
      horizontalTitleGap: 16,
      title: name == null
          ? null
          : DefaultTextStyle(
              style: Theme.of(context).textTheme.labelLarge!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: name,
            ),
      trailing: Icon(
        CatalystVoicesIcons.chevron_right,
        size: 24,
      ),
      onTap: onTap,
    );
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
