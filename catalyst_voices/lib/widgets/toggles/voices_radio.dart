import 'package:flutter/material.dart';

class VoicesRadio<T extends Object> extends StatelessWidget {
  final T value;

  final T? groupValue;

  final ValueChanged<T?>? onChanged;

  const VoicesRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
