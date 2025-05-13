import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final String? username;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ProfileAvatar({
    super.key,
    this.size = 40.0,
    required this.username,
    this.textStyle,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final username = this.username;

    final child = switch (true) {
      _ when username != null && username.isNotEmpty => _Username(
          username,
          style: textStyle,
          size: size,
        ),
      _ => _Placeholder(size: size),
    };

    return VoicesAvatar(
      onTap: onTap,
      radius: size / 2,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: username != null ? const EdgeInsets.all(6) : EdgeInsets.zero,
      icon: child,
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double size;

  const _Placeholder({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAssets.icons.avatarPlaceholder.buildIcon(size: size);
  }
}

class _Username extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double size;

  const _Username(
    this.data, {
    required this.style,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = (style ?? const TextStyle()).copyWith(
      height: 1,
      fontSize: size * 0.6,
      fontWeight: FontWeight.bold,
    );

    return Text(
      data.first!.capitalize(),
      style: effectiveTextStyle,
    );
  }
}
