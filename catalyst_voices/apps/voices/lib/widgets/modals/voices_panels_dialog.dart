import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Commonly used structure for panels dialogs.
///
/// Form factor arranging
/// - Desktop -> panels are disabled horizontally.
/// - Mobile -> only main Panel is displayed and takes full screen.
///
/// Size of dialogs responds to screen size changes. On mobile takes as much space as possible.
class VoicesPanelsDialog extends StatelessWidget {
  final List<VoicesPanelsDialogPanel> panels;
  final int mainPanelIndex;
  final bool showClose;

  VoicesPanelsDialog({
    Key? key,
    required Widget first,
    required Widget second,
    bool showClose = true,
    EdgeInsets firstPadding = const EdgeInsets.all(20),
    EdgeInsets secondPadding = const EdgeInsets.all(20),
    bool isSecondMain = true,
  }) : this._(
         key: key,
         showClose: showClose,
         panels: [
           VoicesPanelsDialogPanel(child: first, padding: firstPadding),
           VoicesPanelsDialogPanel(child: second, padding: secondPadding),
         ],
         mainPanelIndex: isSecondMain ? 1 : 0,
       );

  const VoicesPanelsDialog._({
    super.key,
    required this.panels,
    required this.mainPanelIndex,
    this.showClose = true,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPanelDialog(
      constraints: ResponsiveBoxConstraints.from(
        fallback: const BoxConstraints.tightFor(width: 900, height: 600),
        xs: const BoxConstraints.tightForFinite(),
      ),
      child: ResponsiveChild(
        xs: (context) {
          return _VerticalPanels(
            panels,
            mainPanelIndex: mainPanelIndex,
          );
        },
        other: (context) {
          return _SideBySidePanels(panels);
        },
      ),
    );
  }
}

class VoicesPanelsDialogPanel {
  final EdgeInsets padding;
  final Widget child;

  VoicesPanelsDialogPanel({
    this.padding = const EdgeInsets.all(20),
    required this.child,
  });
}

class _Panel extends StatelessWidget {
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Widget child;

  const _Panel({
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: padding,
      child: this.child,
    );

    final backgroundColor = this.backgroundColor;
    if (backgroundColor != null) {
      child = ColoredBox(color: backgroundColor, child: child);
    }

    return child;
  }
}

class _SideBySidePanels extends StatelessWidget {
  final List<VoicesPanelsDialogPanel> panels;

  const _SideBySidePanels(this.panels);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: panels
          .mapIndexed((index, element) {
            return _Panel(
              key: ValueKey('${index}Panel'),
              padding: element.padding,
              backgroundColor: index == 0
                  ? Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey
                  : null,
              child: element.child,
            );
          })
          .map((e) => Expanded(child: e))
          .toList(),
    );
  }
}

class _VerticalPanels extends StatelessWidget {
  final List<VoicesPanelsDialogPanel> panels;
  final int mainPanelIndex;

  const _VerticalPanels(
    this.panels, {
    required this.mainPanelIndex,
  });

  @override
  Widget build(BuildContext context) {
    final panel = panels[mainPanelIndex];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Panel(
            key: ValueKey('${mainPanelIndex}Panel'),
            padding: panel.padding,
            child: panel.child,
          ),
        ],
      ),
    );
  }
}
