import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:catalyst_voices_assets/generated/colors.gen.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComingSoonTitle extends StatelessWidget {
  const ComingSoonTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      height: 122,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(color: VoicesColors.lightPrimary),
              fontSize: 53,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  l10n.comingSoonTitle1,
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ),
          DefaultTextStyle(
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(color: VoicesColors.lightPrimary),
              fontSize: 53,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
            child: AnimatedTextKit(
              pause: const Duration(milliseconds: 1200),
              animatedTexts: [
                TyperAnimatedText(
                  '',
                  speed: Duration.zero,
                ),
                TyperAnimatedText(
                  l10n.comingSoonTitle2,
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
