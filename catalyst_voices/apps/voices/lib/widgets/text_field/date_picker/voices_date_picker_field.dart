import 'package:catalyst_voices/widgets/text_field/date_picker/date_picker_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

part 'voices_calendar_picker.dart';
part 'voices_time_picker.dart';

enum DateTimePickerType { date, time }

class ScrollControllerProvider extends InheritedWidget {
  final ScrollController scrollController;

  const ScrollControllerProvider({
    super.key,
    required this.scrollController,
    required super.child,
  });

  static ScrollController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ScrollControllerProvider>();
    return provider!.scrollController;
  }

  @override
  bool updateShouldNotify(ScrollControllerProvider oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}

class VoicesDatePicker extends StatefulWidget {
  final DatePickerController controller;
  const VoicesDatePicker({
    super.key,
    required this.controller,
  });

  @override
  State<VoicesDatePicker> createState() => _VoicesDatePickerState();
}

class _VoicesDatePickerState extends State<VoicesDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FieldPicker(
          controller: widget.controller.calendarPickerController,
          pickerType: DateTimePickerType.date,
        ),
        _FieldPicker(
          controller: widget.controller.timePickerController,
          pickerType: DateTimePickerType.time,
          timeZone: 'UTC',
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}

class _FieldPicker extends StatefulWidget {
  final FieldDatePickerController controller;
  final DateTimePickerType pickerType;
  final String timeZone;
  const _FieldPicker({
    required this.controller,
    required this.pickerType,
    this.timeZone = '',
  });

  @override
  State<_FieldPicker> createState() => _FieldPickerState();
}

class _FieldPickerState extends State<_FieldPicker> {
  OverlayEntry? _overlayEntry;
  VoidCallback? _scrollListener;

  @override
  void dispose() {
    super.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void dateOnTap() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _removeOverlay();

      _showOverlay(
        VoicesCalendarDatePicker(
          onDateSelected: (value) {
            _removeOverlay();
          },
          cancelEvent: _removeOverlay,
        ),
      );
    }
  }

  void timeOnTap() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay(
        const VoicesTimePicker(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VoicesTextField(
            controller: widget.controller,
            validator: (value) => widget.controller.validate(value),
            decoration: _getInputDecoration(context),
            onFieldSubmitted: (String value) {},
            showSuffix: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Positioned(
            right: 0,
            child: VoicesIconButton(
              child: _getIcon.buildIcon(),
              onTap: () => widget.pickerType == DateTimePickerType.date
                  ? dateOnTap()
                  : timeOnTap(),
            ),
          ),
        ],
      ),
    );
  }

  double get _getWidth => switch (widget.pickerType) {
        DateTimePickerType.date => 210,
        DateTimePickerType.time => 160,
      };

  SvgGenImage get _getIcon => switch (widget.pickerType) {
        DateTimePickerType.date => VoicesAssets.icons.calendar,
        DateTimePickerType.time => VoicesAssets.icons.clock,
      };

  VoicesTextFieldDecoration _getInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return VoicesTextFieldDecoration(
      fillColor: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.colors.outlineBorderVariant!,
          width: 0.75,
        ),
        borderRadius: switch (widget.pickerType) {
          DateTimePickerType.date => const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          DateTimePickerType.time => const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
        },
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: 2,
        ),
        borderRadius: switch (widget.pickerType) {
          DateTimePickerType.date => const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          DateTimePickerType.time => const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
        },
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colors.errorContainer!,
          width: 2,
        ),
        borderRadius: switch (widget.pickerType) {
          DateTimePickerType.date => const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          DateTimePickerType.time => const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
        },
      ),
      hintText: switch (widget.pickerType) {
        DateTimePickerType.date => 'DD/MM/YYYY',
        DateTimePickerType.time => '00:00 ${widget.timeZone}',
      },
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: theme.colors.textDisabled,
      ),
    );
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

  void _removeOverlay() {
    final scrollController = ScrollControllerProvider.of(context);
    if (_scrollListener != null) {
      scrollController.removeListener(_scrollListener!);
    }
    _scrollListener = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
