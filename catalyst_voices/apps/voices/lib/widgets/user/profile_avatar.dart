import 'package:catalyst_voices/widgets/widgets.dart';
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
    final effectiveTextStyle = (textStyle ?? const TextStyle()).copyWith(
      height: 1,
      fontSize: size * 0.6,
      fontWeight: FontWeight.bold,
    );

    return VoicesAvatar(
      onTap: onTap,
      radius: size / 2,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: const EdgeInsets.all(6),
      icon: Text(
        username?.first?.capitalize() ?? '',
        style: effectiveTextStyle,
      ),
    );
  }
}
