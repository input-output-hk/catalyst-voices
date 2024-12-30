import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/text_field/voices_date_time_text_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class VoicesDateFieldController extends ValueNotifier<DateTime?> {
  VoicesDateFieldController([super._value]);
}

class VoicesDateField extends StatefulWidget {
  final VoicesDateFieldController? controller;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTime?>? onFieldSubmitted;
  final VoidCallback? onCalendarTap;
  final bool dimBorder;
  final BorderRadius borderRadius;

  const VoicesDateField({
    super.key,
    this.controller,
    this.onChanged,
    required this.onFieldSubmitted,
    this.onCalendarTap,
    this.dimBorder = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<VoicesDateField> createState() => _VoicesDateFieldState();
}

class _VoicesDateFieldState extends State<VoicesDateField> {
  late final TextEditingController _textEditingController;
  late final MaskTextInputFormatter dateFormatter;

  VoicesDateFieldController? _controller;

  VoicesDateFieldController get _effectiveController {
    return widget.controller ?? (_controller ??= VoicesDateFieldController());
  }

  String get _pattern => 'dd/MM/yyyy';

  @override
  void initState() {
    final initialDate = _effectiveController.value;
    final initialText = _convertDateToText(initialDate);

    _textEditingController = TextEditingController(text: initialText);
    _textEditingController.addListener(_handleTextChanged);

    _effectiveController.addListener(_handleDateChanged);

    dateFormatter = MaskTextInputFormatter(
      mask: _pattern,
      filter: {
        'd': RegExp('[0-9]'),
        'M': RegExp('[0-9]'),
        'y': RegExp('[0-9]'),
      },
      type: MaskAutoCompletionType.eager,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant VoicesDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(_handleDateChanged);
      (widget.controller ?? _controller)?.addListener(_handleDateChanged);

      final date = _effectiveController.value;
      _textEditingController.text = _convertDateToText(date);
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
    final onFieldSubmitted = widget.onFieldSubmitted;

    return VoicesDateTimeTextField(
      controller: _textEditingController,
      onChanged: onChanged != null
          ? (value) => onChanged(_convertTextToDate(value))
          : null,
      validator: _validate,
      hintText: _pattern.toUpperCase(),
      onFieldSubmitted: onFieldSubmitted != null
          ? (value) => onFieldSubmitted(_convertTextToDate(value))
          : null,
      suffixIcon: ExcludeFocus(
        child: VoicesIconButton(
          onTap: widget.onCalendarTap,
          child: VoicesAssets.icons.calendar.buildIcon(),
        ),
      ),
      borderRadius: widget.borderRadius,
      dimBorder: widget.dimBorder,
      inputFormatters: [dateFormatter],
    );
  }

  void _handleTextChanged() {
    final date = _convertTextToDate(_textEditingController.text);
    if (_effectiveController.value != date) {
      _effectiveController.value = date;
    }
  }

  void _handleDateChanged() {
    final text = _convertDateToText(_effectiveController.value);
    if (_textEditingController.text != text) {
      _textEditingController.text = text;
    }
  }

  String _convertDateToText(DateTime? value) {
    if (value == null) {
      return '';
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year;

    return '$day/$month/$year';
  }

  DateTime? _convertTextToDate(String value) {
    if (value.isEmpty) return null;

    final parts = value.split('/');
    if (parts.length != 3) return null;

    try {
      final reformatted = '${parts[2]}-${parts[1]}-${parts[0]}';
      final formatDt = DateTime.parse(reformatted);

      if (formatDt.month < 1 || formatDt.month > 12) return null;
      if (formatDt.day < 1 || formatDt.day > 31) return null;
      if (formatDt.year < 1900 || formatDt.year > 2100) return null;

      return formatDt;
    } catch (e) {
      return null;
    }
  }

  VoicesTextFieldValidationResult _validate(String value) {
    final today = DateTime.now();
    final maxDate = DateTime(today.year + 1, today.month, today.day);

    if (value.isEmpty) {
      return const VoicesTextFieldValidationResult.success();
    }

    final l10n = context.l10n;

    if (value.length != 10) {
      return VoicesTextFieldValidationResult.error(
        '${l10n.format}: ${_pattern.toUpperCase()}',
      );
    }

    final dateRegex = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    if (!dateRegex.hasMatch(value)) {
      return VoicesTextFieldValidationResult.error(
        '${l10n.format}: ${_pattern.toUpperCase()}',
      );
    }

    final parts = value.split('/');
    final reformatted = '${parts[2]}-${parts[1]}-${parts[0]}';

    // Need this because DateTime.parse accepts out-of-range component values
    // and interprets them as overflows into the next larger component
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final formatDt = DateTime.parse(reformatted);
    if (month < 1 || month > 12) {
      return VoicesTextFieldValidationResult.error(
        '${l10n.format}: ${_pattern.toUpperCase()}',
      );
    }
    if (day < 1 || day > 31) {
      return VoicesTextFieldValidationResult.error(
        l10n.datePickerDaysInMonthError,
      );
    }

    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day > daysInMonth) {
      return VoicesTextFieldValidationResult.error(
        l10n.datePickerDaysInMonthError,
      );
    }
    if (formatDt.isBefore(today.subtract(const Duration(days: 1))) ||
        formatDt.isAfter(maxDate)) {
      return VoicesTextFieldValidationResult.error(
        l10n.datePickerDateRangeError,
      );
    }

    return const VoicesTextFieldValidationResult.success();
  }
}
