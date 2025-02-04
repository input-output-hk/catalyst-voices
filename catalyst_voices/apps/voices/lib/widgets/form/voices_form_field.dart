import 'package:flutter/material.dart';

class VoicesFormField<T> extends FormField<T> {
  final T? value;
  final ValueChanged<T?> onChanged;

  const VoicesFormField({
    super.key,
    required this.value,
    required this.onChanged,
    required super.builder,
    super.validator,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  FormFieldState<T> createState() => VoicesFormFieldState<T>();
}

class VoicesFormFieldState<T> extends FormFieldState<T> {
  @override
  void initState() {
    super.initState();

    setValue(_widget.value);
  }

  @override
  void didUpdateWidget(VoicesFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_widget.value != oldWidget.value) {
      setValue(_widget.value);
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _widget.onChanged(value);
  }

  VoicesFormField<T> get _widget => widget as VoicesFormField<T>;
}
