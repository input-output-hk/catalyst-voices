import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Widget for [Space] [VoicesAvatar] adaptation.
class SpaceAvatar extends StatelessWidget {
  final Space data;

  /// See [VoicesAvatar.onTap].
  final VoidCallback? onTap;

  /// See [VoicesAvatar.padding].
  final EdgeInsets padding;

  /// See [VoicesAvatar.radius].
  final double radius;

  const SpaceAvatar(
    this.data, {
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAvatar(
      icon: data.icon.buildIcon(),
      backgroundColor: data.backgroundColor(context),
      foregroundColor: data.foregroundColor(context),
      padding: padding,
      radius: radius,
    );
  }
}
