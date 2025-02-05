import 'package:catalyst_voices/widgets/pickers/voices_calendar_picker.dart';
import 'package:catalyst_voices/widgets/pickers/voices_time_picker.dart';
import 'package:catalyst_voices/widgets/text_field/voices_date_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_time_field.dart';
import 'package:flutter/material.dart';

typedef DateTimeParts = ({DateTime date, TimeOfDay time});

enum PickerType { date, time }

final class VoicesDateTimeFieldController extends ValueNotifier<DateTime?> {
  VoicesDateTimeFieldController([super._value]);
}

class VoicesDateTimeField extends StatefulWidget {
  final VoicesDateTimeFieldController? controller;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTime?>? onFieldSubmitted;
  final String? timeZone;

  const VoicesDateTimeField({
    super.key,
    this.controller,
    this.onChanged,
    required this.onFieldSubmitted,
    this.timeZone,
  });

  @override
  State<VoicesDateTimeField> createState() => _VoicesDateTimeFieldState();
}

class _VoicesDateTimeFieldState extends State<VoicesDateTimeField> {
  late final VoicesDateFieldController _dateController;
  late final VoicesTimeFieldController _timeController;

  final GlobalKey _dateFiledKey = GlobalKey();
  final GlobalKey _timeFieldKey = GlobalKey();

  VoicesDateTimeFieldController? _controller;

  VoicesDateTimeFieldController get _effectiveController {
    return widget.controller ??
        (_controller ??= VoicesDateTimeFieldController());
  }

  OverlayEntry? _overlayEntry;
  PickerType? _pickerType;
  VoidCallback? _scrollListener;
  bool _isDateOverlayOpen = false;
  bool _isTimeOverlayOpen = false;

  @override
  void initState() {
    super.initState();

    final dateTime = _effectiveController.value;
    final parts = dateTime != null ? _convertDateTimeToParts(dateTime) : null;

    _effectiveController.addListener(_handleDateTimeChanged);

    _dateController = VoicesDateFieldController(parts?.date);
    _dateController.addListener(_handleDateChanged);

    _timeController = VoicesTimeFieldController(parts?.time);
    _timeController.addListener(_handleTimeChanged);
  }

  @override
  void didUpdateWidget(covariant VoicesDateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _controller)
          ?.removeListener(_handleDateTimeChanged);
      (widget.controller ?? _controller)?.addListener(_handleDateTimeChanged);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 220),
          child: VoicesDateField(
            key: _dateFiledKey,
            controller: _dateController,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            dimBorder: _isDateOverlayOpen,
            onCalendarTap: _showDatePicker,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 200),
          child: VoicesTimeField(
            key: _timeFieldKey,
            controller: _timeController,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(16),
            ),
            dimBorder: _isTimeOverlayOpen,
            onClockTap: _showTimePicker,
            onFieldSubmitted: (_) {
              widget.onFieldSubmitted?.call(_effectiveController.value);
            },
            timeZone: widget.timeZone,
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker() async {
    final picker = VoicesCalendarDatePicker(
      initialDate: _dateController.value,
      onDateSelected: (value) {
        _removeOverlay();
        _dateController.value = value;
      },
      cancelEvent: _removeOverlay,
    );

    final initialPosition = _getRenderBoxOffset(_dateFiledKey);
    _pickerType = PickerType.date;

    _showOverlay(
      initialPosition: initialPosition,
      child: picker,
    );
  }

  Future<void> _showTimePicker() async {
    final picker = VoicesTimePicker(
      onTap: (value) {
        _removeOverlay();
        _timeController.value = value;
      },
      selectedTime: _timeController.value,
      timeZone: widget.timeZone,
    );

    final initialPosition = _getRenderBoxOffset(_timeFieldKey);
    _pickerType = PickerType.time;

    _showOverlay(
      initialPosition: initialPosition,
      child: picker,
    );
  }

  void _handleDateTimeChanged() {
    final dateTime = _effectiveController.value;

    final parts = dateTime != null ? _convertDateTimeToParts(dateTime) : null;

    if (_dateController.value != parts?.date) {
      _dateController.value = parts?.date;
    }

    if (_timeController.value != parts?.time) {
      _timeController.value = parts?.time;
    }
  }

  void _handleDateChanged() => _syncControllers();

  void _handleTimeChanged() => _syncControllers();

  void _syncControllers() {
    final date = _dateController.value;
    final time = _timeController.value;

    final dateTime = date != null && time != null
        ? DateTime(date.year, date.month, date.day, time.hour, time.minute)
        : null;

    if (_effectiveController.value != dateTime) {
      _effectiveController.value = dateTime;
    }
  }

  DateTimeParts? _convertDateTimeToParts(DateTime value) {
    final date = DateTime(value.year, value.month, value.day);
    final time = TimeOfDay(hour: value.hour, minute: value.minute);

    return (date: date, time: time);
  }

  void _showOverlay({
    Offset initialPosition = Offset.zero,
    required Widget child,
  }) {
    FocusScope.of(context).unfocus();

    if (_pickerType != null) {
      _removeOverlay();
    }

    setState(() {
      if (_pickerType == PickerType.date) {
        _isDateOverlayOpen = true;
      } else {
        _isTimeOverlayOpen = true;
      }
    });

    final overlay = Overlay.of(context, rootOverlay: true);
    final scrollPosition = Scrollable.maybeOf(context)?.position;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: MouseRegion(
              opaque: false,
              hitTestBehavior: HitTestBehavior.translucent,
              child: GestureDetector(
                onTapDown: (details) async {
                  final tapPosition = details.globalPosition;
                  final dateBox = _getRenderBox(_dateFiledKey);
                  final timeBox = _getRenderBox(_timeFieldKey);

                  if (_isBoxTapped(dateBox, tapPosition)) {
                    return _handleTap(PickerType.date);
                  } else if (_isBoxTapped(timeBox, tapPosition)) {
                    return _handleTap(PickerType.time);
                  } else {
                    _removeOverlay();
                  }
                },
                behavior: HitTestBehavior.translucent,
                excludeFromSemantics: true,
                onPanUpdate: null,
                onPanDown: null,
                onPanCancel: null,
                onPanEnd: null,
                onPanStart: null,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: initialPosition.dy + 50 - (scrollPosition?.pixels ?? 0),
            left: initialPosition.dx,
            child: child,
          ),
        ],
      ),
    );

    if (scrollPosition != null) {
      void listener() {
        if (_overlayEntry != null) {
          _overlayEntry?.markNeedsBuild();
        }
      }

      scrollPosition.addListener(listener);
      _scrollListener = listener;
    }

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      setState(() {
        if (_pickerType == PickerType.date) {
          _isDateOverlayOpen = false;
        } else {
          _isTimeOverlayOpen = false;
        }
      });

      final scrollPosition = Scrollable.maybeOf(context)?.position;
      if (scrollPosition != null && _scrollListener != null) {
        scrollPosition.removeListener(_scrollListener!);
      }

      _overlayEntry?.remove();
      _overlayEntry = null;
      _scrollListener = null;
      _pickerType = null;
    }
  }

  Offset _getRenderBoxOffset(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) {
      return Offset.zero;
    }

    return renderObject.localToGlobal(Offset.zero);
  }

  RenderBox? _getRenderBox(GlobalKey key) {
    return key.currentContext?.findRenderObject() as RenderBox?;
  }

  bool _isBoxTapped(RenderBox? box, Offset tapPosition) {
    return box != null &&
        (box.localToGlobal(Offset.zero) & box.size).contains(tapPosition);
  }

  Future<void> _handleTap(PickerType pickerType) async {
    _removeOverlay();
    if (pickerType == PickerType.date) {
      await _showDatePicker();
    } else {
      await _showTimePicker();
    }
  }
}
