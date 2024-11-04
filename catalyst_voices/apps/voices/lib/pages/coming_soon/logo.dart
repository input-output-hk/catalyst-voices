import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComingSoonLogo extends StatelessWidget {
  const ComingSoonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CatalystSvgPicture.asset(
          VoicesAssets.images.catalystLogo.path,
          width: 202,
        ),
        Container(
          margin: const EdgeInsets.only(left: 13, bottom: 6),
          child: Text(
            l10n.comingSoonSubtitle,
            style: GoogleFonts.notoSans(
              textStyle: const TextStyle(color: VoicesColors.lightPrimary),
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
