import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class StayInvolvedActionButton extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const StayInvolvedActionButton({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: VoicesFilledButton(
        onTap: onTap,
        trailing: trailing,
        child: Text(title),
      ),
    );
  }
}
