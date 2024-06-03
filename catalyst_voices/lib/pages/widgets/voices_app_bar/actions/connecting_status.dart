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
      icon: const Icon(Icons.refresh),
      label: Text(context.l10n.connectingStatusLabelText),
    );
  }
}
