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
  OverlayEntry? _overlayEntry;
  VoidCallback? _scrollListener;

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
    final scrollController = ScrollControllerProvider.of(context);
    if (_scrollListener != null) {
      scrollController.removeListener(_scrollListener!);
    }
    _scrollListener = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onRemoveOverlay?.call();
  }

  void _showOverlay(Widget child) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox?;
    final scrollController = ScrollControllerProvider.of(context);
    final initialPosition = renderBox!.localToGlobal(
      Offset(0, scrollController.offset),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: MouseRegion(
              opaque: false,
              child: GestureDetector(
                onTap: _removeOverlay,
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
            top: initialPosition.dy +
                50 -
                (scrollController.hasClients ? scrollController.offset : 0),
            left: initialPosition.dx,
            child: child,
          ),
        ],
      ),
    );

    void listener() {
      if (_overlayEntry != null) {
        _overlayEntry?.markNeedsBuild();
      }
    }

    scrollController.addListener(listener);
    _scrollListener = listener;

    overlay.insert(_overlayEntry!);
  }

  VoicesTextFieldDecoration _getInputDecoration(
    BuildContext context,
    Widget suffixIcon,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return VoicesTextFieldDecoration(
      suffixIcon: suffixIcon,
      fillColor: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.colors.outlineBorderVariant!,
          width: 0.75,
        ),
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
      errorMaxLines: 2,
    );
  }
}

class _CalendarFieldPickerState extends _BasePickerState<CalendarFieldPicker> {
  void _onTap() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _removeOverlay();
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
        validator: (value) => widget.controller.validate(value),
        decoration: _getInputDecoration(
          context,
          VoicesIconButton(
            onTap: _onTap,
            child: _getIcon.buildIcon(),
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
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay(
        VoicesTimePicker(
          onTap: (value) {
            _removeOverlay();
            widget.controller.setValue(value);
          },
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
        validator: (value) => widget.controller.validate(value),
        decoration: _getInputDecoration(
          context,
          VoicesIconButton(
            onTap: _onTap,
            child: _getIcon.buildIcon(),
          ),
        ),
        onFieldSubmitted: (String value) {},
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
