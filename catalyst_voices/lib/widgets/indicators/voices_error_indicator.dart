import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VoicesAssets.icons.exclamation.buildIcon(
            color: Theme.of(context).colors.iconsError,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(height: 1),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 10),
            VoicesTextButton(
              leading: VoicesAssets.icons.refresh.buildIcon(),
              onTap: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ],
      ),
    );
  }
}
