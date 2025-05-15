import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A banner that indicates a lack of internet connection.
///
/// Includes a refresh button, which is displayed only on desktop-sized screens.
/// The [onRefresh] callback is triggered when the refresh button is pressed.
/// If no [onRefresh] callback is provided, the button will appear disabled.
///
/// The banner is only visible when there is no internet connection and is
/// typically used in scenarios where users need to be alerted to connectivity
/// issues.
///
/// **Example Usage:**
/// ```dart
/// NoInternetConnectionBanner(
///   onRefresh: () {
///     // Handle refresh logic here
///   },
/// )
/// ```
class NoInternetConnectionBanner extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoInternetConnectionBanner({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldButtonDisplay = constraints.maxWidth > 744;
        final foregroundColor = Theme.of(context).colorScheme.errorContainer;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CatalystSvgIcon.asset(
                          VoicesAssets.icons.wifi.path,
                          color: foregroundColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.noConnectionBannerTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: foregroundColor),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      context.l10n.noConnectionBannerDescription,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: foregroundColor),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              if (shouldButtonDisplay) ...[
                const SizedBox(height: 16),
                VoicesTextButton(
                  onTap: onRefresh,
                  child: Text(
                    context.l10n.noConnectionBannerRefreshButtonText,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colors.onErrorVariant,
                        ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
