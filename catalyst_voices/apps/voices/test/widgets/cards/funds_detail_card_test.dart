import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

class _FakeVoicesLocalizations extends Fake implements VoicesLocalizations {
  @override
  String get campaignTreasury => 'Campaign Treasury';
  @override
  String get categoryBudget => 'Category Budget';
  @override
  String get campaignTotalAsk => 'Campaign Total Ask';
  @override
  String get currentAsk => 'Current Ask';
  @override
  String get campaignTreasuryDescription =>
      'Total budget, including ecosystem incentives';
  @override
  String get fundsAvailableForCategory => 'Funds available for this category';
  @override
  String get maximumAsk => 'Maximum Ask';
  @override
  String get minimumAsk => 'MinimumAsk';
}

void main() {
  late _FakeVoicesLocalizations l10n;

  setUpAll(() {
    l10n = _FakeVoicesLocalizations();
  });

  group(FundsDetailCard, () {
    group(FundsDetailCardType.category, () {
      testWidgets('Displays corrects translation', (tester) async {
        await tester.pumpApp(
          const Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: 100,
                totalAsk: 100,
                askRange: Range(min: 100, max: 100),
                type: FundsDetailCardType.category,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(l10n.categoryBudget), findsOne);
        expect(find.text(l10n.fundsAvailableForCategory), findsOne);
        expect(find.text(l10n.currentAsk), findsOne);
      });

      testWidgets('Displays corrects values', (tester) async {
        await tester.pumpApp(
          const Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: 1,
                totalAsk: 2,
                askRange: Range(min: 3, max: 4),
                type: FundsDetailCardType.category,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('1'), findsOne);
        expect(find.textContaining('2'), findsOne);
        expect(find.textContaining('3'), findsOne);
        expect(find.textContaining('4'), findsOne);
      });
    });

    group(FundsDetailCardType.found, () {
      testWidgets('Displays corrects translation', (tester) async {
        await tester.pumpApp(
          const Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: 100,
                totalAsk: 100,
                askRange: Range(min: 100, max: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(l10n.campaignTreasury), findsOne);
        expect(find.text(l10n.campaignTotalAsk), findsOne);
        expect(find.text(l10n.campaignTreasuryDescription), findsOne);
      });

      testWidgets('Displays corrects values', (tester) async {
        await tester.pumpApp(
          const Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: 1,
                totalAsk: 2,
                askRange: Range(min: 3, max: 4),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('1'), findsOne);
        expect(find.textContaining('2'), findsOne);
        expect(find.textContaining('3'), findsOne);
        expect(find.textContaining('4'), findsOne);
      });
    });
  });
}
