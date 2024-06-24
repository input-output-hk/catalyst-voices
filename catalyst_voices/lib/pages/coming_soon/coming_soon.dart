import 'package:catalyst_voices/pages/coming_soon/description.dart';
import 'package:catalyst_voices/pages/coming_soon/logo.dart';
import 'package:catalyst_voices/pages/coming_soon/title.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

final class ComingSoonPage extends StatelessWidget {
  static const comingSoonPageKey = Key('ComingSoon');

  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: comingSoonPageKey,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CatalystImage.asset(
              VoicesAssets.images.comingSoonBkg.path,
            ).image,
            fit: BoxFit.cover,
          ),
        ),
        child: ResponsivePadding(
          xs: const EdgeInsets.only(left: 17),
          sm: const EdgeInsets.only(left: 119),
          md: const EdgeInsets.only(left: 150),
          lg: const EdgeInsets.only(left: 150),
          other: const EdgeInsets.only(left: 150),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 356),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComingSoonLogo(),
                  ComingSoonTitle(),
                  ComingSoonDescription(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
