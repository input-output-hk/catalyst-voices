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
    return VoicesIconButton.outlined(
      onTap: toggleTimelineVisibility,
      child: isTimelineVisible
          ? VoicesAssets.icons.topBarFilled.buildIcon(
              color: Theme.of(context).colorScheme.primary,
            )
          : VoicesAssets.icons.topBar.buildIcon(
              color: Theme.of(context).colorScheme.primary,
            ),
    );
  }

  void toggleTimelineVisibility() {
    setState(() {
      isTimelineVisible = !isTimelineVisible;
    });
  }
}
