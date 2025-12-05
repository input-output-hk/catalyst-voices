part of 'workspace_header.dart';

class _TimelineToggleButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _TimelineToggleButton({
    required this.onPressed,
  });

  @override
  State<_TimelineToggleButton> createState() => _TimelineToggleButtonState();
}

class _TimelineToggleButtonState extends State<_TimelineToggleButton> {
  bool _isTimelineVisible = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.primary;

    return VoicesIconButton.outlined(
      onTap: _toggleTimelineVisibility,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: _isTimelineVisible
          ? VoicesAssets.icons.topBarFilled.buildIcon(
              color: iconColor,
            )
          : VoicesAssets.icons.topBar.buildIcon(
              color: iconColor,
            ),
    );
  }

  void _toggleTimelineVisibility() {
    setState(() => _isTimelineVisible = !_isTimelineVisible);
    widget.onPressed?.call();
  }
}
