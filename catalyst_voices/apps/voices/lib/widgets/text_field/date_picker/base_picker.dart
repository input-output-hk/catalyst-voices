part of 'voices_date_picker_field.dart';

abstract class BasePicker extends StatefulWidget {
  final VoidCallback? onRemoveOverlay;
  final DateTimePickerType pickerType;

  const BasePicker({
    super.key,
    required this.pickerType,
    this.onRemoveOverlay,
  });
}

class CalendarFieldPicker extends BasePicker {
  final CalendarPickerController controller;

  const CalendarFieldPicker({
    super.key,
    required this.controller,
    super.onRemoveOverlay,
  }) : super(pickerType: DateTimePickerType.date);

  @override
  State<CalendarFieldPicker> createState() => _CalendarFieldPickerState();
}

class TimeFieldPicker extends BasePicker {
  final TimePickerController controller;

  final String timeZone;

  const TimeFieldPicker({
    super.key,
    required this.controller,
    required this.timeZone,
    super.onRemoveOverlay,
  }) : super(pickerType: DateTimePickerType.time);

  @override
  State<TimeFieldPicker> createState() => _TimeFieldPickerState();
}

abstract class _BasePickerState<T extends BasePicker> extends State<T> {
  static _BasePickerState? _activePicker;
  OverlayEntry? _overlayEntry;
  VoidCallback? _scrollListener;
  bool _isOverlayOpen = false;

  @override
  void dispose() {
    super.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double get _getWidth => switch (widget.pickerType) {
        DateTimePickerType.date => 220,
        DateTimePickerType.time => 170,
      };

  BorderRadius get _getBorderRadius => switch (widget.pickerType) {
        DateTimePickerType.date => const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        DateTimePickerType.time => const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
      };

  String get _getHintText => switch (widget.pickerType) {
        DateTimePickerType.date => 'DD/MM/YYYY',
        DateTimePickerType.time when widget is TimeFieldPicker =>
          '00:00 ${(widget as TimeFieldPicker).timeZone}',
        _ => '00:00',
      };

  SvgGenImage get _getIcon => switch (widget.pickerType) {
        DateTimePickerType.date => VoicesAssets.icons.calendar,
        DateTimePickerType.time => VoicesAssets.icons.clock,
      };

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
      _activePicker = null;
    }
  }

  RenderBox? _getRenderBox(GlobalKey key) {
    return key.currentContext?.findRenderObject() as RenderBox?;
  }

  bool _isBoxTapped(RenderBox? box, Offset tapPosition) {
    return box != null &&
        (box.localToGlobal(Offset.zero) & box.size).contains(tapPosition);
  }

  void _handleCalendarTap() {
    _activePicker?._removeOverlay();
    final calendarState = calendarKey.currentState;
    if (calendarState is _CalendarFieldPickerState) {
      calendarState._onTap();
    }
  }

  void _handleTimeTap() {
    _activePicker?._removeOverlay();
    final timeState = timeKey.currentState;
    if (timeState is _TimeFieldPickerState) {
      timeState._onTap();
    }
  }

  void _showOverlay(Widget child) {
    FocusScope.of(context).unfocus();
    if (_activePicker != null && _activePicker != this) {
      _activePicker!._removeOverlay();
    }
    setState(() {
      _isOverlayOpen = true;
    });
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox?;
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final initialPosition = renderBox!.localToGlobal(
      Offset.zero,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: MouseRegion(
              opaque: false,
              hitTestBehavior: HitTestBehavior.translucent,
              child: GestureDetector(
                onTapDown: (details) {
                  final tapPosition = details.globalPosition;
                  final calendarBox = _getRenderBox(calendarKey);
                  final timeBox = _getRenderBox(timeKey);

                  if (_isBoxTapped(calendarBox, tapPosition)) {
                    return _handleCalendarTap();
                  } else if (_isBoxTapped(timeBox, tapPosition)) {
                    return _handleTimeTap();
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

    _activePicker = this;
    overlay.insert(_overlayEntry!);
  }

  VoicesTextFieldDecoration _getInputDecoration(
    BuildContext context,
    Widget suffixIcon,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final borderSide = _isOverlayOpen
        ? BorderSide(
            color: theme.primaryColor,
            width: 2,
          )
        : BorderSide(
            color: theme.colors.outlineBorderVariant!,
            width: 0.75,
          );
    return VoicesTextFieldDecoration(
      suffixIcon: suffixIcon,
      fillColor: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: borderSide,
        borderRadius: _getBorderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: 2,
        ),
        borderRadius: _getBorderRadius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
        borderRadius: _getBorderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
        borderRadius: _getBorderRadius,
      ),
      hintText: _getHintText,
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: theme.colors.textDisabled,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
      errorMaxLines: 2,
    );
  }
}

class _CalendarFieldPickerState extends _BasePickerState<CalendarFieldPicker> {
  void _onTap() {
    if (_BasePickerState._activePicker == this) {
      _removeOverlay();
    } else {
      _showOverlay(
        VoicesCalendarDatePicker(
          initialDate: widget.controller.selectedValue,
          onDateSelected: (value) {
            _removeOverlay();
            widget.controller.setValue(value);
          },
          cancelEvent: _removeOverlay,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth,
      child: VoicesTextField(
        controller: widget.controller,
        validator: (value) {
          final status = widget.controller.validate(value);
          return status.message(context.l10n, widget.controller.pattern);
        },
        decoration: _getInputDecoration(
          context,
          ExcludeFocus(
            child: VoicesIconButton(
              onTap: _onTap,
              child: _getIcon.buildIcon(),
            ),
          ),
        ),
        onFieldSubmitted: (String value) {},
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

class _TimeFieldPickerState extends _BasePickerState<TimeFieldPicker> {
  void _onTap() {
    if (_BasePickerState._activePicker == this) {
      _removeOverlay();
    } else {
      _showOverlay(
        VoicesTimePicker(
          onTap: (value) {
            _removeOverlay();
            widget.controller.setValue(value);
          },
          selectedTime: widget.controller.text,
          timeZone: widget.timeZone,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth,
      child: VoicesTextField(
        controller: widget.controller,
        validator: (value) {
          final status = widget.controller.validate(value);
          return status.message(context.l10n, widget.controller.pattern);
        },
        decoration: _getInputDecoration(
          context,
          ExcludeFocus(
            child: VoicesIconButton(
              onTap: _onTap,
              child: _getIcon.buildIcon(),
            ),
          ),
        ),
        onFieldSubmitted: (String value) {},
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
