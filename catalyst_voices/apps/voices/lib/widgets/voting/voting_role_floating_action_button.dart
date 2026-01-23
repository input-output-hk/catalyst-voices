import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VotingRoleFloatingActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final VoicesFloatingActionButtonWidgetBuilder builder;

  const VotingRoleFloatingActionButton({
    super.key,
    this.onTap,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFloatingActionButton(
      backgroundColor: null,
      backgroundGradient: null,
      foregroundColor: null,
      onTap: onTap,
      builder: builder,
    );
  }
}
