import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A generic error state with optional retry button.
class VoicesErrorIndicator extends StatelessWidget {
  /// The description of the error.
  final String message;

  /// The callback called when refresh button is tapped.
  ///
  /// If null then retry button is hidden.
  final VoidCallback? onRetry;

  const VoicesErrorIndicator({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIndicator(
      type: VoicesIndicatorType.error,
      icon: VoicesAssets.icons.exclamation,
      message: Text(message),
      action: Offstage(
        offstage: onRetry == null,
        child: VoicesTextButton(
          key: const Key('ErrorRetryBtn'),
          leading: VoicesAssets.icons.refresh.buildIcon(),
          onTap: onRetry,
          child: Text(context.l10n.retry),
        ),
      ),
    );
  }
}
