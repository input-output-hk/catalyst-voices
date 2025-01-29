import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _tooltipVisible = false;
  bool _highlightCopied = false;

  Timer? _highlightCopiedFadeoutTimer;

  @override
  void initState() {
    super.initState();

    _effectiveData = _buildTextData();
    _tooltipVisible = _isTooltipVisible();
  }

  @override
  void didUpdateWidget(covariant CatalystIdText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data ||
        widget.isCompact != oldWidget.isCompact) {
      _effectiveData = _buildTextData();
      _tooltipVisible = _isTooltipVisible();
    }
  }

  @override
  void dispose() {
    _highlightCopiedFadeoutTimer?.cancel();
    _highlightCopiedFadeoutTimer = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _effectiveData.isEmpty,
      child: _TapDetector(
        onTap: _copyDataToClipboard,
        onHoverExit: _handleHoverExit,
        child: TooltipVisibility(
          visible: _tooltipVisible,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: VoicesPlainTooltip(
                  message: widget.data,
                  // Do not constraint width.
                  constraints: const BoxConstraints(),
                  child: _Chip(
                    _effectiveData,
                    onTap: _copyDataToClipboard,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _Copy(
                showCheck: _highlightCopied,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyDataToClipboard() async {
    final data = ClipboardData(text: widget.data);
    await Clipboard.setData(data);

    if (mounted) {
      setState(_doHighlightCopied);
    }
  }

  void _handleHoverExit() {
    if (_highlightCopied && _highlightCopiedFadeoutTimer == null) {
      _scheduleRemoveHighlight();
    }
  }

  void _doHighlightCopied() {
    _highlightCopied = true;

    _highlightCopiedFadeoutTimer?.cancel();
    _highlightCopiedFadeoutTimer = null;
  }

  void _scheduleRemoveHighlight() {
    _highlightCopiedFadeoutTimer = Timer(
      const Duration(seconds: 1),
      () => setState(_removeHighlight),
    );
  }

  void _removeHighlight() {
    _highlightCopied = false;

    if (_highlightCopiedFadeoutTimer?.isActive ?? false) {
      _highlightCopiedFadeoutTimer?.cancel();
    }
    _highlightCopiedFadeoutTimer = null;
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

  bool _isTooltipVisible() {
    return widget.isCompact && _effectiveData.length < widget.data.length;
  }
}

class _TapDetector extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onHoverExit;
  final Widget child;

  const _TapDetector({
    required this.onTap,
    required this.onHoverExit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (event) => onHoverExit(),
      child: GestureDetector(
        onTap: onTap,
        // there is a gap between text and copy
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String data;
  final VoidCallback onTap;

  const _Chip(
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
  final bool showCheck;

  const _Copy({
    this.showCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = showCheck ? theme.colors.success : theme.colorScheme.primary;
    final asset = showCheck
        ? VoicesAssets.icons.clipboardCheck
        : VoicesAssets.icons.clipboardCopy;

    return CatalystSvgIcon.asset(
      asset.path,
      color: color,
    );
  }
}
