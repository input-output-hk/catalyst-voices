import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

// TODO(dm): update doc
/// Commonly used structure for desktop dialogs.
///
/// Keep in mind that this dialog has fixed size of 900x600 and
/// is always adding close button in top right corner.
class VoicesPanelsDialog extends StatelessWidget {
  final Widget first;
  final Widget second;
  final bool showClose;
  final EdgeInsets firstPadding;
  final EdgeInsets secondPadding;

  const VoicesPanelsDialog({
    super.key,
    required this.first,
    required this.second,
    this.showClose = true,
    this.firstPadding = const EdgeInsets.all(20),
    this.secondPadding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPanelDialog(
      constraints: ResponsiveBoxConstraints.from(
        fallback: const BoxConstraints.tightFor(width: 900, height: 600),
        xs: const BoxConstraints.tightFor(width: 450, height: 600),
      ),
      child: ResponsiveChild(
        xs: (context) {
          return _VerticalPanels(
            header: first,
            body: second,
            headerPadding: firstPadding,
            bodyPadding: secondPadding,
          );
        },
        other: (context) {
          return _SideBySidePanels(
            left: first,
            right: second,
            leftPadding: firstPadding,
            rightPadding: secondPadding,
          );
        },
      ),
    );
  }
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
  final Widget left;
  final Widget right;
  final EdgeInsets leftPadding;
  final EdgeInsets rightPadding;

  const _SideBySidePanels({
    required this.left,
    required this.right,
    required this.leftPadding,
    required this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _Panel(
            key: const ValueKey('FirstPanel'),
            padding: leftPadding,
            backgroundColor: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            child: left,
          ),
        ),
        Expanded(
          child: _Panel(
            key: const ValueKey('SecondPanel'),
            padding: rightPadding,
            child: right,
          ),
        ),
      ],
    );
  }
}

class _VerticalPanels extends StatelessWidget {
  final Widget header;
  final Widget body;
  final EdgeInsets headerPadding;
  final EdgeInsets bodyPadding;

  const _VerticalPanels({
    required this.header,
    required this.body,
    required this.headerPadding,
    required this.bodyPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _Panel(
            key: const ValueKey('SecondPanel'),
            padding: bodyPadding,
            child: body,
          ),
        ],
      ),
    );
  }
}
