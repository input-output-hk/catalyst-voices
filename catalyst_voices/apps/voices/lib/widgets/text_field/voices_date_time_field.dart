import 'package:catalyst_voices/widgets/pickers/voices_calendar_picker.dart';
import 'package:catalyst_voices/widgets/pickers/voices_time_picker.dart';
import 'package:catalyst_voices/widgets/text_field/voices_date_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_time_field.dart';
import 'package:flutter/material.dart';

typedef DateTimeParts = ({DateTime date, TimeOfDay time});

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
  VoidCallback? _scrollListener;
  bool _isOverlayOpen = false;

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
            dimBorder: _isOverlayOpen,
            onCalendarTap: _showDatePicker,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 170),
          child: VoicesTimeField(
            key: _timeFieldKey,
            controller: _timeController,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(16),
            ),
            dimBorder: _isOverlayOpen,
            onClockTap: _showTimePicker,
            onFieldSubmitted: (_) {
              widget.onFieldSubmitted?.call(_effectiveController.value);
            },
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

    if (_isOverlayOpen) {
      _removeOverlay();
    }

    setState(() {
      _isOverlayOpen = true;
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
                onTapDown: (_) => _removeOverlay(),
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
        _isOverlayOpen = false;
      });

      final scrollPosition = Scrollable.maybeOf(context)?.position;
      if (scrollPosition != null && _scrollListener != null) {
        scrollPosition.removeListener(_scrollListener!);
      }

      _overlayEntry?.remove();
      _overlayEntry = null;
      _scrollListener = null;
    }
  }

  Offset _getRenderBoxOffset(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) {
      return Offset.zero;
    }

    return renderObject.localToGlobal(Offset.zero);
  }
}
