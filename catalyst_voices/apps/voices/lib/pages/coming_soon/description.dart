import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:catalyst_voices_assets/generated/colors.gen.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComingSoonDescription extends StatelessWidget {
  const ComingSoonDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: DefaultTextStyle(
        style: GoogleFonts.notoSans(
          textStyle: const TextStyle(color: VoicesColors.lightTextOnPrimary),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        child: AnimatedTextKit(
          pause: const Duration(milliseconds: 2000),
          animatedTexts: [
            // We need an empty initial text to trigger an initial
            // pause
            TyperAnimatedText('', speed: Duration.zero),
            TyperAnimatedText(
              context.l10n.comingSoonDescription,
              speed: const Duration(milliseconds: 30),
            ),
          ],
          totalRepeatCount: 1,
        ),
      ),
    );
  }
}
