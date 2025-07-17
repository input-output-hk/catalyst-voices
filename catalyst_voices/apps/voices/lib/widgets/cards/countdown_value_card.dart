import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/widgets.dart';

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
    final digits = _getDigits(value);
    final hasTens = digits.length > 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 167,
      width: 144,
      decoration: BoxDecoration(
        color: context.colors.onSurfaceSecondary08,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DigitWidget(
                key: const ValueKey('tens'),
                digit: hasTens ? digits[0] : 0,
                textAlign: TextAlign.left,
              ),
              _DigitWidget(
                key: const ValueKey('ones'),
                digit: digits.last,
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
    );
  }

  List<int> _getDigits(int value) {
    return value.toString().split('').map(int.parse).toList();
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
      style: context.textTheme.displayMedium?.copyWith(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: context.colorScheme.primary,
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
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
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
                    child: Transform.translate(
                      offset: Offset(0, _animation.value * _fallDistance),
                      child: Opacity(
                        opacity: 1 - _animation.value,
                        child: _DigitText(value: _previousDigit, textAlign: widget.textAlign),
                      ),
                    ),
                  ),
                  // New digit - falls from top of container
                  Positioned(
                    top: -_fallDistance + _offset,
                    left: 0,
                    right: 0,
                    height: _digitHeight,
                    child: Transform.translate(
                      offset: Offset(0, _animation.value * _fallDistance),
                      child: Opacity(
                        opacity: _animation.value,
                        child: _DigitText(value: widget.digit, textAlign: widget.textAlign),
                      ),
                    ),
                  ),
                ] else ...[
                  Positioned(
                    top: _offset,
                    child: _DigitText(value: widget.digit, textAlign: widget.textAlign),
                  ),
                ],
              ],
            );
          },
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
