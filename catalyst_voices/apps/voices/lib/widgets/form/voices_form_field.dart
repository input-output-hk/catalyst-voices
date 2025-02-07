import 'package:flutter/material.dart';

/// A [FormField] which keeps a value which can be dynamically updated
/// by the parent.
///
/// A traditional form field only accepts a [FormField.initialValue] which
/// can be set once, here the value can be updated as many times as needed.
class VoicesFormField<T> extends FormField<T> {
  /// The value passed by the parent which this [FormField] initializes with.
  /// If a user makes an edit then the current form field
  /// value might be different than this value.
  ///
  /// If parent changes this property and it is different
  /// than previous one the form field value will be updated.
  final T? value;

  /// A callback called whenever the form field value changes.
  ///
  /// It should only be called if the change originates from the user.
  /// If the parent updates this form field then this callback
  /// should not be called back.
  final ValueChanged<T?>? onChanged;

  /// The default constructor for the [VoicesFormField].
  const VoicesFormField({
    super.key,
    required this.value,
    this.onChanged,
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
