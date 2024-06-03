import 'package:flutter/material.dart';

class RolePicker extends StatelessWidget {
  final String currentRole;
  final void Function()? onPressed;

  const RolePicker({
    super.key,
    required this.currentRole,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      label: Text(currentRole),
    );
  }
}
