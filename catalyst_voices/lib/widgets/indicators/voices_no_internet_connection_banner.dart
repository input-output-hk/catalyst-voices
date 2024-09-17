import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class NoInternetConnectionBanner extends StatelessWidget {
  final VoidCallback onRefresh;

  const NoInternetConnectionBanner({
    super.key,
    this.onRefresh = _noop,
  });

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldButtonDisplay = constraints.maxWidth > 744;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: VoicesColors.darkAvatarsError,
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
                          color: VoicesColors.darkIconsOnImage,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.noConnectionBannerTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: VoicesColors.darkTextOnPrimaryLevel0,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      context.l10n.noConnectionBannerDescription,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: VoicesColors.darkTextOnPrimaryLevel0,
                          ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              if (shouldButtonDisplay) const SizedBox(height: 16),
              if (shouldButtonDisplay)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VoicesTextButton(
                      onTap: onRefresh,
                      child: Text(
                        context.l10n.noConnectionBannerRefreshButtonText,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: VoicesColors.darkTextOnPrimaryLevel0,
                            ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
