import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VoicesSnackBar extends StatelessWidget {
  final VoicesSnackBarType snackBarType;
  final VoidCallback? onRefreshPressed;
  final VoidCallback? onLearnMorePressed;
  final VoidCallback? onOkPressed;
  final EdgeInsetsGeometry? padding;

  const VoicesSnackBar({
    super.key,
    required this.snackBarType,
    this.onRefreshPressed,
    this.onLearnMorePressed,
    this.onOkPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: snackBarType.backgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: Icon(
                size: 24,
                CatalystVoicesIcons.x,
                color: Theme.of(context).colors.iconsForeground,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      size: 20,
                      snackBarType.icon(context),
                      color: snackBarType.iconColor(context),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      snackBarType.title(context),
                      style: TextStyle(
                        color: snackBarType.titleColor(context),
                        fontSize:
                            Theme.of(context).textTheme.titleMedium?.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.titleMedium?.fontWeight,
                        fontFamily:
                            Theme.of(context).textTheme.titleMedium?.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48,
                ),
                child: Row(
                  children: [
                    Text(
                      snackBarType.message(context),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(
                  left: 36,
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: snackBarType == VoicesSnackBarType.success
                          ? onOkPressed
                          : onRefreshPressed,
                      child: Text(
                        snackBarType == VoicesSnackBarType.success
                            ? context.l10n.snackbarOkButtonText
                            : context.l10n.snackbarRefreshButtonText,
                        style: TextStyle(
                          color: Theme.of(context).colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onLearnMorePressed,
                      child: Text(
                        context.l10n.snackbarMoreButtonText,
                        style: TextStyle(
                          color: Theme.of(context).colors.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: this,
        padding: padding,
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
