import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// An indicator for a [PasswordStrength].
///
/// Fills in all the available horizontal space,
/// use a [SizedBox] to limit it's width.
final class VoicesPasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength passwordStrength;

  const VoicesPasswordStrengthIndicator({
    super.key,
    required this.passwordStrength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(passwordStrength: passwordStrength),
        const SizedBox(height: 16),
        _Indicator(passwordStrength: passwordStrength),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final PasswordStrength passwordStrength;

  const _Label({required this.passwordStrength});

  @override
  Widget build(BuildContext context) {
    return Text(
      switch (passwordStrength) {
        PasswordStrength.weak => context.l10n.weakPasswordStrength,
        PasswordStrength.normal => context.l10n.normalPasswordStrength,
        PasswordStrength.strong => context.l10n.goodPasswordStrength,
      },
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _Indicator extends StatelessWidget {
  static const double _backgroundTrackHeight = 4;
  static const double _foregroundTrackHeight = 6;
  static const double _tracksGap = 8;

  final PasswordStrength passwordStrength;

  const _Indicator({required this.passwordStrength});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _foregroundTrackHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidthOfAllGaps =
              (PasswordStrength.values.length - 1) * _tracksGap;
          final availableWidth = constraints.maxWidth - totalWidthOfAllGaps;
          final trackWidth = availableWidth / PasswordStrength.values.length;

          return Stack(
            children: [
              Positioned.fill(
                top: 1,
                child: Container(
                  height: _backgroundTrackHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colors.onSurfaceSecondary08,
                    borderRadius: BorderRadius.circular(_backgroundTrackHeight),
                  ),
                ),
              ),
              for (final strength in PasswordStrength.values)
                if (passwordStrength.index >= strength.index)
                  Positioned(
                    left: strength.index * (trackWidth + _tracksGap),
                    width: trackWidth,
                    child: _Track(passwordStrength: strength),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _Track extends StatelessWidget {
  final PasswordStrength passwordStrength;

  const _Track({required this.passwordStrength});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _Indicator._foregroundTrackHeight,
      decoration: BoxDecoration(
        color: switch (passwordStrength) {
          PasswordStrength.weak => Theme.of(context).colorScheme.error,
          PasswordStrength.normal => Theme.of(context).colors.warning,
          PasswordStrength.strong => Theme.of(context).colors.success,
        },
        borderRadius: BorderRadius.circular(_Indicator._foregroundTrackHeight),
      ),
    );
  }
}
