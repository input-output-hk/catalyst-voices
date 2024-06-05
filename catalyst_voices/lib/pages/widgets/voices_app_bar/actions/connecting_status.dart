import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ConnectingStatus extends StatelessWidget {
  const ConnectingStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: null,
      icon: const Icon(
        CatalystVoicesIcons.refresh,
        size: 18,
      ),
      label: Text(context.l10n.connectingStatusLabelText),
    );
  }
}
