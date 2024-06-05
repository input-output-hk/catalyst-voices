import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/material.dart';

import 'common.dart';

void main() {
  patrol('Test Landing page', (PatrolIntegrationTester $) async {
    await createApp($);
    await Future<void>.delayed(const Duration(seconds: 15));
    final BuildContext context = $.tester.element(find.byType(Container).first);
    final localization = VoicesLocalizations.of(context);
    final comingSoonText = localization?.comingSoonDescription;
    final comingSoonTitle1 = localization?.comingSoonTitle1;
    final comingSoonTitle2 = localization?.comingSoonTitle2;
    expect($(comingSoonText), findsOneWidget);
    expect($(comingSoonTitle1), findsOneWidget);
    expect($(comingSoonTitle2), findsOneWidget);
  });
}
