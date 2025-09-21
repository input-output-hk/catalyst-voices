import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _titleKey = 'title';

class BannerContent extends StatefulWidget {
  final BannerNotification notification;

  const BannerContent({
    super.key,
    required this.notification,
  });

  @override
  State<BannerContent> createState() => _BannerContentState();
}

class _BannerContentState extends State<BannerContent> {
  final _gestureRecognizers = <String, GestureRecognizer>{};

  @override
  Widget build(BuildContext context) {
    final title = widget.notification.title(context);
    final message = widget.notification.message(context);

    final text = '{$_titleKey}: ${message.text}';
    final placeholders = <String, CatalystNotificationTextPart>{
      _titleKey: CatalystNotificationTextPart(text: title, bold: true),
      ...message.placeholders,
    };

    return PlaceholderRichText(
      text,
      style: context.textTheme.labelLarge,
      placeholderSpanBuilder: (context, placeholder) {
        if (!placeholders.containsKey(placeholder)) {
          return TextSpan(text: placeholder);
        }

        final replacement = placeholders[placeholder]!;
        final onTap = replacement.onTap;

        return TextSpan(
          text: replacement.text,
          style: TextStyle(
            fontWeight: replacement.bold ? FontWeight.bold : null,
            decoration: replacement.underlined ? TextDecoration.underline : null,
          ),
          recognizer: onTap != null
              ? _gestureRecognizers.putIfAbsent(
                  placeholder,
                  () => TapGestureRecognizer()..onTap = () => onTap(context),
                )
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    for (final key in _gestureRecognizers.keys) {
      _gestureRecognizers.remove(key)?.dispose();
    }
    super.dispose();
  }
}
