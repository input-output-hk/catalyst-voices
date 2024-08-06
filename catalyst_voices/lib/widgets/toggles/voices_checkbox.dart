import 'package:flutter/material.dart';

///
class VoicesCheckbox extends StatelessWidget {
  ///
  final bool value;

  ///
  final ValueChanged<bool>? onChanged;

  ///
  final bool isError;

  const VoicesCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      // forcing null unwrapping because we're not allowing null value
      onChanged: onChanged != null ? (value) => onChanged!(value!) : null,
      isError: isError,
    );
  }
}
