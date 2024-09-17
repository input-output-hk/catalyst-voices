import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        Text(
                          'No internet connection',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: VoicesColors.darkTextOnPrimaryLevel0,
                                  ),
                        ),
                      ],
                    ),
                    Text(
                      'Your internet is playing hide and seek. Check your internet connection, or try again in a moment.',
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
                        'Refresh',
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
