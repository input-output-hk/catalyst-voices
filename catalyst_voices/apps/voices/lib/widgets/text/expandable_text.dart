import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String data;
  final int trimLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;

  const ExpandableText(
    this.data, {
    required super.key,
    this.trimLines = 3,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isUserExpanded = false;
  bool _needsTrim = false;
  TextPainter? _textPainter;

  bool get _isExpanded => !_needsTrim || _isUserExpanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _needsTrim = _calculateNeedsTrim(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              widget.data,
              maxLines: _isExpanded ? null : widget.trimLines,
              style: widget.style,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              locale: widget.locale,
              softWrap: widget.softWrap,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
              textScaler: widget.textScaler,
            ),
            if (_needsTrim) _ToggleExpandChip(isExpanded: _isExpanded, onTap: _toggleIsExpanded),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textPainter = _buildPainter();
  }

  @override
  void didUpdateWidget(ExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data ||
        widget.trimLines != oldWidget.trimLines ||
        widget.textDirection != widget.textDirection ||
        widget.locale != oldWidget.locale ||
        widget.textAlign != oldWidget.textAlign ||
        widget.textScaler != oldWidget.textScaler) {
      _textPainter = _buildPainter();
    }
  }

  TextPainter _buildPainter() {
    return TextPainter(
      text: TextSpan(text: widget.data, style: widget.style),
      maxLines: widget.trimLines,
      textDirection: widget.textDirection ?? Directionality.of(context),
      locale: widget.locale,
      textAlign: widget.textAlign ?? TextAlign.start,
      textScaler: widget.textScaler ?? TextScaler.noScaling,
    );
  }

  bool _calculateNeedsTrim({
    double minWidth = 0,
    double maxWidth = double.infinity,
  }) {
    final textPainter = _textPainter ??= _buildPainter();

    // ignore: cascade_invocations
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  void _toggleIsExpanded() {
    setState(() {
      _isUserExpanded = !_isUserExpanded;
    });
  }
}

class _ToggleExpandChip extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _ToggleExpandChip({
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textData = isExpanded ? context.l10n.expandableTextLess : context.l10n.expandableTextMore;
    final iconData = isExpanded ? VoicesAssets.icons.minus : VoicesAssets.icons.plus;

    final theme = Theme.of(context);

    final foregroundColor = theme.linksPrimary;

    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AffixDecorator(
            gap: 2,
            iconTheme: IconThemeData(size: 12, color: foregroundColor),
            prefix: iconData.buildIcon(),
            child: Text(
              textData,
              style: context.textTheme.bodyMedium?.copyWith(color: foregroundColor),
            ),
          ),
        ),
      ),
    );
  }
}
