import 'dart:async';
import 'dart:ui';

import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class CountDownValueCard extends StatelessWidget {
  final int value;
  final String unit;

  const CountDownValueCard({
    super.key,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final digitTheme = AnimatedVoicesCountdownTheme.of(context);

    return Container(
      margin: digitTheme.margin,
      constraints: BoxConstraints.tightFor(
        width: digitTheme.width,
        height: digitTheme.height,
      ),
      decoration: BoxDecoration(
        color: digitTheme.backgroundColor(context),
        borderRadius: BorderRadius.circular(digitTheme.borderRadius),
        border: Border.all(color: digitTheme.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(digitTheme.borderRadius),
        child: _ConditionalBlurLayer(
          blurSigmaX: digitTheme.blurSigmaX,
          blurSigmaY: digitTheme.blurSigmaY,
          child: _CountdownCardContent(
            value: value,
            unit: unit,
            themeData: digitTheme,
          ),
        ),
      ),
    );
  }
}

class _AnimatedDigit extends StatelessWidget {
  final Widget child;
  final double fallDistance;
  final bool isPreviousDigit;
  final Animation<double> animation;

  const _AnimatedDigit({
    required this.animation,
    required this.child,
    required this.fallDistance,
    required this.isPreviousDigit,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value * fallDistance),
          child: Opacity(
            opacity: isPreviousDigit ? 1 - animation.value : animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _ConditionalBlurLayer extends StatelessWidget {
  final double blurSigmaX;
  final double blurSigmaY;
  final Widget child;

  const _ConditionalBlurLayer({
    required this.blurSigmaX,
    required this.blurSigmaY,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Skip expensive BackdropFilter when blur is 0
    if (blurSigmaX == 0 && blurSigmaY == 0) {
      return child;
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
      child: child,
    );
  }
}

class _CountdownCardContent extends StatelessWidget {
  final int value;
  final String unit;
  final AnimatedVoicesCountdownThemeData themeData;

  const _CountdownCardContent({
    required this.value,
    required this.unit,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    final digits = _getDigits(value);

    return Padding(
      padding: themeData.padding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Offstage(
                offstage: digits.length < 3,
                child: _DigitWidget(
                  key: const ValueKey('hundreds'),
                  digit: digits[0],
                  textAlign: TextAlign.right,
                  themeData: themeData.digitThemeData,
                ),
              ),
              _DigitWidget(
                key: const ValueKey('tens'),
                digit: digits.length < 3 ? digits[0] : digits[1],
                textAlign: TextAlign.right,
                themeData: themeData.digitThemeData,
              ),
              _DigitWidget(
                key: const ValueKey('ones'),
                digit: digits.length < 3 ? digits[1] : digits[2],
                textAlign: TextAlign.left,
                themeData: themeData.digitThemeData,
              ),
            ],
          ),
          Positioned(
            bottom: themeData.unitTextBottomPosition,
            child: Text(
              unit,
              style: themeData.unitTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getDigits(int value) {
    if (value < 10) return [0, value];
    if (value < 100) return [value ~/ 10, value % 10];
    return [value ~/ 100, (value ~/ 10) % 10, value % 10];
  }
}

class _DigitText extends StatelessWidget {
  final int value;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  const _DigitText({required this.value, required this.textAlign, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toString(),
      textAlign: textAlign,
      style: textStyle,
    );
  }
}

class _DigitWidget extends StatefulWidget {
  final int digit;
  final TextAlign textAlign;
  final VoicesDigitThemeData themeData;

  const _DigitWidget({
    super.key,
    required this.digit,
    required this.textAlign,
    required this.themeData,
  });

  @override
  State<_DigitWidget> createState() => _DigitWidgetState();
}

class _DigitWidgetState extends State<_DigitWidget> with SingleTickerProviderStateMixin {
  late int _previousDigit;
  late AnimationController _animationController;
  late Animation<double> _animation;

  VoicesDigitThemeData get themeData => widget.themeData;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: themeData.digitWidth,
        height: themeData.digitHeight,
        child: ClipRect(
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              if (_previousDigit != widget.digit) ...[
                // Previous digit - moves down and fades out
                Positioned(
                  top: themeData.offset,
                  left: 0,
                  right: 0,
                  height: themeData.digitHeight,
                  child: _AnimatedDigit(
                    animation: _animation,
                    fallDistance: themeData.fallDistance,
                    isPreviousDigit: true,
                    child: _DigitText(
                      value: _previousDigit,
                      textAlign: widget.textAlign,
                      textStyle: themeData.digitTextStyle,
                    ),
                  ),
                ),
                // New digit - falls from top of container
                Positioned(
                  top: -themeData.fallDistance + themeData.offset,
                  left: 0,
                  right: 0,
                  height: themeData.digitHeight,
                  child: _AnimatedDigit(
                    animation: _animation,
                    fallDistance: themeData.fallDistance,
                    isPreviousDigit: false,
                    child: _DigitText(
                      value: widget.digit,
                      textAlign: widget.textAlign,
                      textStyle: themeData.digitTextStyle,
                    ),
                  ),
                ),
              ] else ...[
                Positioned(
                  top: themeData.offset,
                  child: _DigitText(
                    value: widget.digit,
                    textAlign: widget.textAlign,
                    textStyle: themeData.digitTextStyle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_DigitWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _previousDigit = oldWidget.digit;
      unawaited(_animationController.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _previousDigit = widget.digit;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }
}
