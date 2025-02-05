part of 'workspace_header.dart';

class TimelineToggleButton extends StatefulWidget {
  const TimelineToggleButton({super.key});

  @override
  State<TimelineToggleButton> createState() => TimelineToggleButtonState();
}

class TimelineToggleButtonState extends State<TimelineToggleButton> {
  bool isTimelineVisible = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.primary;

    return VoicesIconButton.outlined(
      onTap: toggleTimelineVisibility,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: isTimelineVisible
          ? VoicesAssets.icons.topBarFilled.buildIcon(
              color: iconColor,
            )
          : VoicesAssets.icons.topBar.buildIcon(
              color: iconColor,
            ),
    );
  }

  void toggleTimelineVisibility() {
    setState(() {
      isTimelineVisible = !isTimelineVisible;
    });
  }
}
