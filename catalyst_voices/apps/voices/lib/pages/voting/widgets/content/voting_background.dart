import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VotingBackground extends StatelessWidget {
  const VotingBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white,
            ],
            stops: [-0.5, 0.25],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: CatalystImage.asset(
          context.theme.brandAssets.brand.votingBg(context).path,
          width: double.infinity,
          height: (MediaQuery.sizeOf(context).height * 0.75).clamp(620, 1200),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
