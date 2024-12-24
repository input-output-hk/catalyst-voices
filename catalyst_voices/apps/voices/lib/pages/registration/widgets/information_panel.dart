import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class InformationPanel extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? body;
  final Widget picture;
  final double? progress;

  const InformationPanel({
    super.key,
    required this.title,
    this.subtitle,
    this.body,
    required this.picture,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: title,
          subtitle: subtitle,
          body: body,
        ),
        const SizedBox(height: 12),
        Expanded(
            key: const Key('PictureContainer'), child: Center(child: picture),),
        const SizedBox(height: 12),
        _Footer(
          progress: progress,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? body;

  const _Header({
    required this.title,
    this.subtitle,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel0;

    final subtitle = this.subtitle;
    final body = this.body;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          key: const Key('HeaderTitle'),
          title,
          style: theme.textTheme.titleLarge?.copyWith(color: textColor),
        ),
        if (subtitle != null)
          Text(
            key: const Key('HeaderSubtitle'),
            subtitle,
            style: theme.textTheme.titleMedium?.copyWith(color: textColor),
          ),
        if (body != null)
          Text(
            key: const Key('HeaderBody'),
            body,
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
      ].separatedBy(const SizedBox(height: 12)).toList(),
    );
  }
}

class _Footer extends StatelessWidget {
  final double? progress;

  const _Footer({
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility.maintain(
          visible: progress != null,
          child: AnimatedVoicesLinearProgressIndicator(value: progress ?? 0),
        ),
        const SizedBox(height: 10),
        VoicesLearnMoreButton(onTap: () {}),
      ],
    );
  }
}
