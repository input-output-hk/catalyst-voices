import 'package:flutter/material.dart';

/// A [FormField] which keeps a value which can be dynamically updated
/// by the parent.
///
/// A traditional form field only accepts a [FormField.initialValue] which
/// can be set once, here the value can be updated as many times as needed.
class VoicesFormField<T> extends FormField<T> {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool readOnly;

  const VoicesFormField({
    super.key,
    required this.value,
    this.onChanged,
    this.readOnly = false,
    super.enabled = true,
    required super.builder,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(initialValue: value);

  @override
  FormFieldState<T> createState() => VoicesFormFieldState<T>();
}

class VoicesFormFieldState<T> extends FormFieldState<T> {
  @override
  VoicesFormField<T> get widget => super.widget as VoicesFormField<T>;

  @override
  void didUpdateWidget(VoicesFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      setValue(widget.value);
    }
  }
}
