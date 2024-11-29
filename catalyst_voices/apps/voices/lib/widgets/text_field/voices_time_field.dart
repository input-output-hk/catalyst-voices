import 'package:catalyst_voices/common/ext/time_of_day_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/text_field/voices_date_time_text_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class VoicesTimeFieldController extends ValueNotifier<TimeOfDay?> {
  VoicesTimeFieldController([super._value]);
}

class VoicesTimeField extends StatefulWidget {
  final VoicesTimeFieldController? controller;
  final ValueChanged<TimeOfDay?>? onChanged;
  final ValueChanged<TimeOfDay?>? onFieldSubmitted;
  final VoidCallback? onClockTap;
  final bool dimBorder;
  final BorderRadius borderRadius;
  final String? timeZone;

  const VoicesTimeField({
    super.key,
    this.controller,
    this.onChanged,
    required this.onFieldSubmitted,
    this.onClockTap,
    this.dimBorder = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.timeZone,
  });

  @override
  State<VoicesTimeField> createState() => _VoicesTimeFieldState();
}

class _VoicesTimeFieldState extends State<VoicesTimeField> {
  late final TextEditingController _textEditingController;

  VoicesTimeFieldController? _controller;

  VoicesTimeFieldController get _effectiveController {
    return widget.controller ?? (_controller ??= VoicesTimeFieldController());
  }

  String get _pattern => 'HH:MM';
  String get timeZone => widget.timeZone ?? '';
  late MaskTextInputFormatter timeFormatter;

  @override
  void initState() {
    final initialTime = _effectiveController.value;
    final initialText = _convertTimeToText(initialTime);

    _textEditingController = TextEditingController(text: initialText);
    _textEditingController.addListener(_handleTextChanged);

    _effectiveController.addListener(_handleDateChanged);

    timeFormatter = MaskTextInputFormatter(
      mask: _pattern,
      filter: {
        'H': RegExp('[0-9]'),
        'M': RegExp('[0-9]'),
      },
      type: MaskAutoCompletionType.eager,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant VoicesTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(_handleDateChanged);
      (widget.controller ?? _controller)?.addListener(_handleDateChanged);

      final time = _effectiveController.value;
      _textEditingController.text = _convertTimeToText(time);
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
          ? (value) => onChanged(_convertTextToTime(value))
          : null,
      validator: _validate,
      hintText: '${_pattern.toUpperCase()} $timeZone',
      onFieldSubmitted: onFieldSubmitted != null
          ? (value) => onFieldSubmitted(_convertTextToTime(value))
          : null,
      suffixIcon: ExcludeFocus(
        child: VoicesIconButton(
          onTap: widget.onClockTap,
          child: VoicesAssets.icons.clock.buildIcon(),
        ),
      ),
      dimBorder: widget.dimBorder,
      borderRadius: widget.borderRadius,
      inputFormatters: [timeFormatter],
    );
  }

  void _handleTextChanged() {
    final text = _textEditingController.text;
    final time = _convertTextToTime(text);
    if (_effectiveController.value != time) {
      _effectiveController.value = time;
    }
  }

  void _handleDateChanged() {
    final time = _effectiveController.value;
    final text = _convertTimeToText(time);
    if (_textEditingController.text != text) {
      _textEditingController.text = text;
    }
  }

  String _convertTimeToText(TimeOfDay? value) {
    return value?.formatted ?? '';
  }

  TimeOfDay? _convertTextToTime(String value) {
    if (value.isEmpty) return null;
    if (_validate(value).status != VoicesTextFieldStatus.success) {
      return null;
    }

    try {
      final parts = value.split(':');
      final rawHours = parts[0];
      final rawMinutes = parts[1];

      final hour = int.parse(rawHours);
      final minute = int.parse(rawMinutes);

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  VoicesTextFieldValidationResult _validate(String value) {
    if (value.isEmpty) {
      return const VoicesTextFieldValidationResult.success();
    }
    final l10n = context.l10n;

    final pattern = RegExp(r'^(0?[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$');
    if (!pattern.hasMatch(value)) {
      return VoicesTextFieldValidationResult.error('${l10n.format}: $_pattern');
    }

    return const VoicesTextFieldValidationResult.success();
  }
}
