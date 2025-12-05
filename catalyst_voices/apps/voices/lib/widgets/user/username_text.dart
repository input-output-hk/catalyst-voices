import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
    final effectiveUsername = isAnonymous ? context.l10n.anonymousUsername : username;

    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      fontStyle: isAnonymous ? FontStyle.italic : FontStyle.normal,
    );

    return Text(
      effectiveUsername,
      style: effectiveStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
