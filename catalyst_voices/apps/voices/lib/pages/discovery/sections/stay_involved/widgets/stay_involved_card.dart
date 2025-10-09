import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class StayInvolvedCard extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String description;
  final Widget actions;

  const StayInvolvedCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 565,
        maxWidth: 588,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getGradientColors(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          icon.buildIcon(size: 53),
          const SizedBox(height: 22),
          Text(
            title,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          actions,
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? [
            const Color(0xFFD1EAFF),
            const Color(0xFFCAD6FE),
          ]
        : [
            const Color(0xFF2D3953),
            const Color(0xFF242C42),
          ];
  }
}
