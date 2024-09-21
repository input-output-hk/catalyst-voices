import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// An alert dialog similar to [AlertDialog]
/// but customized to the project needs.
///
/// On extra small screens (mobile) it will fill the whole screen width,
/// on larger screens it will take [_width] amount
/// of horizontal space and be centered.
///
/// The close (x) button will appear if the dialog [isDismissible].
class VoicesAlertDialog extends StatelessWidget {
  static const double _width = 360;

  /// The widget which appears at the top of the dialog next to the (x) button.
  /// Usually a [Text] widget.
  final Widget? title;

  /// The widget which appears below the [title],
  /// usually a [VoicesAvatar] widget.
  final Widget? icon;

  /// The widget appears below the [icon], is less prominent than the [title].
  /// Usually a [Text] widget.
  final Widget? subtitle;

  /// The widget appears below the [subtitle], usually a [Text] widget,
  /// can be multiline.
  final Widget? content;

  /// The list of widgets which appear at the bottom of the dialog,
  /// usually [VoicesFilledButton] or [VoicesTextButton].
  ///
  /// [buttons] are separated with 8px of padding between each other
  /// so you don't need to add your own padding.
  final List<Widget> buttons;

  /// Whether to show a (x) close button.
  final bool isDismissible;

  const VoicesAlertDialog({
    super.key,
    this.title,
    this.icon,
    this.subtitle,
    this.content,
    this.buttons = const [],
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final icon = this.icon;
    final subtitle = this.subtitle;
    final content = this.content;

    return ResponsiveBuilder<double>(
      xs: double.infinity,
      other: _width,
      builder: (context, width) {
        return Dialog(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null || isDismissible)
                    Row(
                      children: [
                        // if widget is dismissible then show an invisible
                        // close button to reserve space on this side of the
                        // row so that the title is centered
                        if (isDismissible)
                          const Visibility(
                            visible: false,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: _CloseButton(),
                          ),
                        Expanded(
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.titleLarge!,
                            textAlign: TextAlign.center,
                            child: title ?? const SizedBox.shrink(),
                          ),
                        ),
                        if (isDismissible) const _CloseButton(),
                      ],
                    ),
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 20,
                        right: 20,
                      ),
                      child: Center(child: icon),
                    ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 20,
                        right: 20,
                      ),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.titleSmall!,
                        textAlign: TextAlign.center,
                        child: subtitle,
                      ),
                    ),
                  if (content != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 20,
                        right: 20,
                      ),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyMedium!,
                        textAlign: TextAlign.center,
                        child: content,
                      ),
                    ),
                  if (buttons.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          ...buttons.separatedBy(const SizedBox(height: 8)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return XButton(
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
