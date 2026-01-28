import 'dart:math' as math;

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_floating_action_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoicesCounterFloatingActionButton extends StatelessWidget {
  final String title;
  final int count;
  final String countLabel;
  final bool useGradient;
  final VoidCallback? onTap;

  const VoicesCounterFloatingActionButton({
    super.key,
    required this.title,
    required this.count,
    required this.countLabel,
    this.useGradient = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFloatingActionButton(
      onTap: onTap,
      backgroundGradient: useGradient ? context.colorScheme.votingGradient : null,
      backgroundColor: !useGradient ? context.colorScheme.primary : null,
      foregroundColor: context.colors.textOnPrimaryWhite,
      builder: (context, isExtended) {
        return isExtended
            ? _Expanded(title: title, count: count, countLabel: countLabel)
            : _Collapsed(count: count);
      },
    );
  }
}

class _Collapsed extends StatelessWidget {
  final int count;

  const _Collapsed({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count',
      style: context.textTheme.titleLarge?.apply(color: context.colors.textOnPrimaryWhite),
    );
  }
}

class _Expanded extends StatelessWidget {
  final String title;
  final int count;
  final String countLabel;

  const _Expanded({
    required this.title,
    required this.count,
    required this.countLabel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Offstage(
          offstage: constraints.maxWidth < 152,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExpandedTitleRow(text: title),
              const Spacer(),
              _ExpandedCounterRow(count: count, label: countLabel),
            ],
          ),
        );
      },
    );
  }
}

class _ExpandedArrowIcon extends StatelessWidget {
  const _ExpandedArrowIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.iconsBackground,
      ),
      padding: const EdgeInsets.all(3.5),
      transform: Matrix4.rotationZ(-45 * (math.pi / 180)),
      transformAlignment: Alignment.center,
      child: VoicesAssets.icons.arrowRight.buildIcon(size: 20),
    );
  }
}

class _ExpandedCounterRow extends StatelessWidget {
  final int count;
  final String label;

  const _ExpandedCounterRow({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      textDirection: TextDirection.ltr,
      spacing: 10,
      children: [
        Text(
          count < 100 ? '$count' : '99+',
          style: GoogleFonts.poppins(
            fontSize: 52,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          maxLines: 1,
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(color: context.colors.textOnPrimaryWhite),
            maxLines: 1,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}

class _ExpandedTitleRow extends StatelessWidget {
  final String text;

  const _ExpandedTitleRow({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.textOnPrimaryWhite,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
          const _ExpandedArrowIcon(),
        ],
      ),
    );
  }
}
