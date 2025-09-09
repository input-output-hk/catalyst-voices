import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// Commonly used structure for desktop dialogs.
///
/// Keep in mind that this dialog has fixed size of 900x600 and
/// is always adding close button in top right corner.
class VoicesPanelsDialog extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool showClose;
  final EdgeInsets leftPadding;
  final EdgeInsets rightPadding;

  const VoicesPanelsDialog({
    super.key,
    required this.left,
    required this.right,
    this.showClose = true,
    this.leftPadding = const EdgeInsets.all(20),
    this.rightPadding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPanelDialog(
      constraints: ResponsiveBoxConstraints.from(
        fallback: const BoxConstraints.tightFor(width: 900, height: 600),
        xs: const BoxConstraints.tightFor(width: 450, height: 600),
      ),
      child: ResponsiveChild(
        sm: (context) {
          return Text('Test');
        },
        other: (context) {
          return _SideBySidePanels(
            left: left,
            right: right,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
          );
        },
      ),
    );
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
          child: Container(
            padding: leftPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            ),
            child: left,
          ),
        ),
        Expanded(
          child: Padding(
            padding: rightPadding,
            child: right,
          ),
        ),
      ],
    );
  }
}
