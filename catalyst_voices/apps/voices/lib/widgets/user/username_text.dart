import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class UsernameText extends StatelessWidget {
  final String? data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const UsernameText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final username = data;
    final isAnonymous = username == null || username.isBlank;
    final displayName = data.asDisplayName(context);

    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      fontStyle: isAnonymous ? FontStyle.italic : FontStyle.normal,
    );

    return Text(
      displayName,
      style: effectiveStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
