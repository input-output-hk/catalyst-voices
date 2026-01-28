import 'package:catalyst_voices/pages/error_page/error_page.dart';
import 'package:catalyst_voices/routes/routing/root_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// 404 not found page.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      image: VoicesAssets.images.notFound404,
      title: context.l10n.notFoundTitle,
      message: context.l10n.notFoundMessage,
      button: VoicesTextButton(
        leading: VoicesAssets.icons.arrowNarrowRight.buildIcon(),
        child: Text(context.l10n.notFoundButton),
        onTap: () => const RootRoute().go(context),
      ),
    );
  }
}
