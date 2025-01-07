import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesDropdownFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  const VoicesDropdownFormField({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      items: items,
      value: value,
      onChanged: onChanged,
      icon: VoicesAssets.icons.chevronDown.buildIcon(),
      style: theme.textTheme.bodyLarge,
    );
  }
}
