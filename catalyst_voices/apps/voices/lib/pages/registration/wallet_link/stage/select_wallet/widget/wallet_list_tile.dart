import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WalletListTile extends StatefulWidget {
  final WalletMetadata wallet;
  final AsyncValueSetter<WalletMetadata> onSelectWallet;

  const WalletListTile({
    super.key,
    required this.wallet,
    required this.onSelectWallet,
  });

  @override
  State<WalletListTile> createState() => _WalletListTileState();
}

class _WalletListTileState extends State<WalletListTile> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return VoicesWalletTile(
      iconSrc: widget.wallet.icon,
      name: Text(widget.wallet.name.capitalize()),
      isLoading: _isLoading,
      onTap: _onSelectWallet,
    );
  }

  Future<void> _onSelectWallet() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await widget.onSelectWallet(widget.wallet).withMinimumDelay();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
