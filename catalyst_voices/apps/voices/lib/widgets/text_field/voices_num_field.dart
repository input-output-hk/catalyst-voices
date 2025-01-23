import 'dart:convert';

import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoicesNumFieldController<T extends num> extends ValueNotifier<T?> {
  VoicesNumFieldController([super.value]);
}

typedef VoicesNumFieldValidator<T extends num> = VoicesTextFieldValidationResult
    Function(T? value, String text);

class VoicesNumField<T extends num> extends StatefulWidget {
  final Codec<T, String> codec;
  final VoicesNumFieldController<T>? controller;
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  final int? maxLength;
  final ValueChanged<T?>? onFieldSubmitted;
  final VoicesTextFieldDecoration? decoration;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<T?>? onChanged;
  final VoicesNumFieldValidator<T>? validator;
  final ValueChanged<VoicesTextFieldStatus>? onStatusChanged;
  final bool enabled;
  final bool readOnly;
  final bool? ignorePointers;

  const VoicesNumField({
    super.key,
    required this.codec,
    this.controller,
    this.statesController,
    this.focusNode,
    this.maxLength,
    required this.onFieldSubmitted,
    this.decoration,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.onStatusChanged,
    this.enabled = true,
    this.readOnly = false,
    this.ignorePointers,
  });

  @override
  State<VoicesNumField<T>> createState() => _VoicesNumFieldState<T>();
}

class _VoicesNumFieldState<T extends num> extends State<VoicesNumField<T>> {
  late final TextEditingController _textEditingController;

  VoicesNumFieldController<T>? _controller;

  VoicesNumFieldController<T> get _effectiveController {
    return widget.controller ?? (_controller ??= VoicesNumFieldController<T>());
  }

  @override
  void initState() {
    super.initState();

    final num = _effectiveController.value;
    final text = _toText(num);

    _textEditingController = TextEditingController()
      ..textWithSelection = text ?? ''
      ..addListener(_handleTextChange);

    _effectiveController.addListener(_handleNumChange);
  }

  @override
  void didUpdateWidget(covariant VoicesNumField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(_handleNumChange);
      (widget.controller ?? _controller)?.addListener(_handleNumChange);

      if (widget.controller == null && oldWidget.controller != null) {
        _controller = VoicesNumFieldController(oldWidget.controller?.value);
      } else if (widget.controller != null && oldWidget.controller == null) {
        _controller?.dispose();
        _controller = null;
      }

      _handleNumChange();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onChanged = widget.onChanged;
    final validator = widget.validator;
    final onFieldSubmitted = widget.onFieldSubmitted;

    return VoicesTextField(
      controller: _textEditingController,
      statesController: widget.statesController,
      focusNode: widget.focusNode,
      maxLines: 1,
      maxLength: widget.maxLength,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        ...?widget.inputFormatters,
      ],
      onChanged: onChanged != null ? (value) => onChanged(_toNum(value)) : null,
      validator:
          validator != null ? (value) => validator(_toNum(value), value) : null,
      onStatusChanged: widget.onStatusChanged,
      onFieldSubmitted: onFieldSubmitted != null
          ? (value) => onFieldSubmitted(_toNum(value))
          : null,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      ignorePointers: widget.ignorePointers,
    );
  }

  void _handleNumChange() {
    final num = _effectiveController.value;
    final text = _toText(num) ?? _textEditingController.text;

    if (_textEditingController.text != text) {
      _textEditingController.textWithSelection = text;
    }
  }

  void _handleTextChange() {
    final text = _textEditingController.text;
    final num = _toNum(text);

    if (_effectiveController.value != num) {
      _effectiveController.value = num;
    }
  }

  String? _toText(T? num) {
    try {
      return num != null ? widget.codec.encode(num) : '';
    } on FormatException {
      return null;
    }
  }

  T? _toNum(String text) {
    try {
      return widget.codec.decode(text);
    } on FormatException {
      return null;
    }
  }
}
