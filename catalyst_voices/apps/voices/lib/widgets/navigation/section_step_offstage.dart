import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:flutter/material.dart';

class SectionStepOffstage extends StatelessWidget {
  final int sectionId;
  final Widget child;

  const SectionStepOffstage({
    super.key,
    required this.sectionId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SectionsControllerScope.of(context),
      builder: (context, value, child) {
        final isVisible = value.openedSections.contains(sectionId);
        return Offstage(
          offstage: !isVisible,
          child: TickerMode(
            enabled: isVisible,
            child: child!,
          ),
        );
      },
      child: child,
    );
  }
}
