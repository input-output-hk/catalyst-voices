import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A [ConnectingStatus] widget that is used to display a status of
/// re-connection. Its look and feel is the same of a button but there is no
/// active actions available from it.
class ConnectingStatus extends StatelessWidget {
  const ConnectingStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: null,
      icon: VoicesAssets.icons.refresh.buildIcon(size: 18),
      label: Text(context.l10n.connectingStatusLabelText),
    );
  }
}
