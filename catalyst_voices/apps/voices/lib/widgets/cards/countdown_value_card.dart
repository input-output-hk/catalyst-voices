import 'dart:ui';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountDownValueCard extends StatelessWidget {
  final int value;
  final String unit;

  const CountDownValueCard({
    super.key,
    required this.value,
    required this.unit,
  });

  Color get _borderColor => Colors.white.withValues(alpha: 0.2);

  @override
  Widget build(BuildContext context) {
    final digits = _getDigits(value);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      constraints: const BoxConstraints(
        minWidth: 144,
        maxHeight: 167,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                    ),
                    _DigitWidget(
                      key: const ValueKey('tens'),
                      digit: digits.length < 3 ? digits[0] : digits[1],
                      textAlign: TextAlign.right,
                    ),
                    _DigitWidget(
                      key: const ValueKey('ones'),
                      digit: digits.length < 3 ? digits[1] : digits[2],
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 35,
                  child: Text(
                    unit,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.03,
                      height: 1,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) => context.theme.isLight
      ? Colors.white.withValues(alpha: 0.2)
      : Colors.black.withValues(alpha: 0.2);

  List<int> _getDigits(int value) {
    final digits = value.toString().characters.map(int.parse).toList();
    if (digits.length == 1) {
      return [0, digits[0]];
    }
    return digits;
  }
}

class _DigitText extends StatelessWidget {
  final int value;
  final TextAlign textAlign;

  const _DigitText({required this.value, required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toString(),
      textAlign: textAlign,
      style: GoogleFonts.robotoMono(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: context.colorScheme.primary,
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
    );
  }
}

class _DigitWidget extends StatefulWidget {
  final int digit;
  final TextAlign textAlign;

  const _DigitWidget({super.key, required this.digit, required this.textAlign});

  @override
  State<_DigitWidget> createState() => _DigitWidgetState();
}

class _DigitWidgetState extends State<_DigitWidget> with SingleTickerProviderStateMixin {
  late int _previousDigit;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double _digitHeight = 160;
  final double _fallDistance = 100;
  final double _offset = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: _digitHeight,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            if (_previousDigit != widget.digit) ...[
              // Previous digit - moves down and fades out
              Positioned(
                top: _offset,
                left: 0,
                right: 0,
                height: _digitHeight,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value * _fallDistance),
                      child: Opacity(
                        opacity: 1 - _animation.value,
                        child: child,
                      ),
                    );
                  },
                  child: _DigitText(value: _previousDigit, textAlign: widget.textAlign),
                ),
              ),
              // New digit - falls from top of container
              Positioned(
                top: -_fallDistance + _offset,
                left: 0,
                right: 0,
                height: _digitHeight,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value * _fallDistance),
                      child: Opacity(
                        opacity: _animation.value,
                        child: child,
                      ),
                    );
                  },
                  child: _DigitText(value: widget.digit, textAlign: widget.textAlign),
                ),
              ),
            ] else ...[
              Positioned(
                top: _offset,
                child: _DigitText(value: widget.digit, textAlign: widget.textAlign),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_DigitWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _previousDigit = oldWidget.digit;
      _animationController.forward(from: 0);
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
