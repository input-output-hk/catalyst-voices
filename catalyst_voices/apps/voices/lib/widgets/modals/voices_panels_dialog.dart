import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Commonly used structure for panels dialogs.
///
/// Form factor arranging
/// - Desktop -> panels are displayed horizontally.
/// - Mobile -> only main Panel is displayed and takes full screen.
///
/// Size of dialogs responds to screen size changes. On mobile takes as much space as possible.
class VoicesPanelsDialog extends StatelessWidget {
  final List<VoicesPanelsDialogPanel> panels;
  final int primaryPanelIndex;
  final bool showClose;

  VoicesPanelsDialog({
    Key? key,
    required Widget primary,
    required Widget secondary,
    bool showClose = true,
    EdgeInsets secondaryPadding = const EdgeInsets.all(20),
    EdgeInsets primaryPadding = const EdgeInsets.all(20),
  }) : this._(
         key: key,
         showClose: showClose,
         panels: [
           VoicesPanelsDialogPanel(child: secondary, padding: secondaryPadding),
           VoicesPanelsDialogPanel(child: primary, padding: primaryPadding),
         ],
         primaryPanelIndex: 1,
       );

  const VoicesPanelsDialog._({
    super.key,
    required this.panels,
    required this.primaryPanelIndex,
    this.showClose = true,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPanelDialog(
      constraints: ResponsiveBoxConstraints.from(
        fallback: const BoxConstraints.tightFor(width: 900, height: 600),
        xs: const BoxConstraints(maxHeight: 600),
      ),
      child: ResponsiveChild(
        xs: (context) {
          return _VerticalPanels(
            panels,
            primaryPanelIndex: primaryPanelIndex,
          );
        },
        sm: (context) {
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
  final int primaryPanelIndex;

  const _VerticalPanels(
    this.panels, {
    required this.primaryPanelIndex,
  });

  @override
  Widget build(BuildContext context) {
    final panel = panels[primaryPanelIndex];

    return _Panel(
      key: ValueKey('${primaryPanelIndex}Panel'),
      padding: panel.padding,
      child: panel.child,
    );
  }
}
