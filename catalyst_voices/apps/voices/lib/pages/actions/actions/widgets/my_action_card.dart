import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class MyActionCard extends StatelessWidget {
  final ActionsCardType type;
  final String backgroundImagePath;
  final Widget? timeRemainingWidget;
  final Widget actionWidget;

  const MyActionCard({
    super.key,
    required this.type,
    required this.backgroundImagePath,
    this.timeRemainingWidget,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 452, maxHeight: 232),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CatalystImage.asset(
            backgroundImagePath,
            scale: 1.5,
          ).image,
          fit: BoxFit.none,
          alignment: const Alignment(-1, -0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LabelText(text: type.labelText(context)),
              ?timeRemainingWidget,
            ],
          ),
          const SizedBox(height: 12),
          _TitleText(text: type.title(context)),
          const SizedBox(height: 36),
          actionWidget,
        ],
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;

  const _LabelText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryWhite,
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String text;

  const _TitleText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.colors.textOnPrimaryWhite,
      ),
    );
  }
}
