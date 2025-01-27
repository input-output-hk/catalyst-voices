import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

const _compactMaxLength = 6;

class CatalystIdText extends StatefulWidget {
  final String data;
  final bool isCompact;

  const CatalystIdText(
    this.data, {
    super.key,
    required this.isCompact,
  });

  @override
  State<CatalystIdText> createState() => _CatalystIdTextState();
}

class _CatalystIdTextState extends State<CatalystIdText> {
  String _effectiveData = '';

  @override
  void initState() {
    super.initState();

    _effectiveData = _buildTextData();
  }

  @override
  void didUpdateWidget(covariant CatalystIdText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data ||
        widget.isCompact != oldWidget.isCompact) {
      _effectiveData = _buildTextData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _effectiveData.isEmpty,
      child: _TapDetector(
        onTap: _copyDataToClipboard,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VoicesPlainTooltip(
              message: widget.data,
              child: _Text(
                _effectiveData,
                onTap: _copyDataToClipboard,
              ),
            ),
            const SizedBox(width: 6),
            const _Copy(),
          ],
        ),
      ),
    );
  }

  Future<void> _copyDataToClipboard() async {
    print('Go');
    //
  }

  String _buildTextData() {
    final data = widget.data;
    final isCompact = widget.isCompact;

    // If isCompact use last _compactMaxLength characters.
    if (isCompact && data.length > _compactMaxLength) {
      final start = data.length - _compactMaxLength;
      return data.substring(start);
    }

    return data;
  }
}

class _TapDetector extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TapDetector({
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        // there is a gap between text and copy
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}

class _Text extends StatelessWidget {
  final String data;
  final VoidCallback onTap;

  const _Text(
    this.data, {
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    final backgroundColor = colors.elevationsOnSurfaceNeutralLv1Grey;
    final foregroundColor = colors.textOnPrimaryLevel1;
    final overlayColor = colors.onSurfaceNeutralOpaqueLv2;

    final textStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: foregroundColor,
    );

    return Material(
      color: backgroundColor,
      shape: const StadiumBorder(),
      textStyle: textStyle,
      child: InkWell(
        customBorder: const StadiumBorder(),
        mouseCursor: SystemMouseCursors.click,
        overlayColor: WidgetStatePropertyAll(overlayColor),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: Text(data),
        ),
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = theme.colorScheme.primary;

    return VoicesAssets.icons.clipboardCopy.buildIcon(
      size: 18,
      color: color,
    );
  }
}
