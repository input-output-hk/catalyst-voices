import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  late _FakeVoicesLocalizations l10n;

  setUpAll(() {
    l10n = _FakeVoicesLocalizations();
  });

  group(FundsDetailCard, () {
    group(FundsDetailCardType.category, () {
      testWidgets('Displays corrects translation', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: MultiCurrencyAmount.single(_adaMajorUnits(100)),
                totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(100)),
                askRange: ComparableRange(
                  min: _adaMajorUnits(100),
                  max: _adaMajorUnits(100),
                ),
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
          Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: MultiCurrencyAmount.single(_adaMajorUnits(1)),
                totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(2)),
                askRange: ComparableRange(
                  min: _adaMajorUnits(3),
                  max: _adaMajorUnits(4),
                ),
                type: FundsDetailCardType.category,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('₳1'), findsOne);
        expect(find.textContaining('₳2'), findsOne);
        expect(find.textContaining('₳3'), findsOne);
        expect(find.textContaining('₳4'), findsOne);
      });
    });

    group(FundsDetailCardType.fund, () {
      testWidgets('Displays corrects translation', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: MultiCurrencyAmount.single(_adaMajorUnits(100)),
                totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(100)),
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
          Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: MultiCurrencyAmount.single(_adaMajorUnits(1)),
                totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(2)),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('₳1'), findsOne);
        expect(find.textContaining('₳2'), findsOne);
      });

      testWidgets('Displays correct multiple values', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Center(
              child: FundsDetailCard(
                allFunds: MultiCurrencyAmount.list([
                  _adaMajorUnits(1),
                  _usdMajorUnits(2),
                ]),
                totalAsk: MultiCurrencyAmount.list([
                  _adaMajorUnits(3),
                  _usdMajorUnits(4),
                ]),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('₳1'), findsOne);
        expect(find.textContaining(r'$2'), findsOne);
        expect(find.textContaining('₳3'), findsOne);
        expect(find.textContaining(r'$4'), findsOne);
      });
    });
  });
}

Money _adaMajorUnits(int majorUnits) {
  return Money.fromMajorUnits(
    currency: const Currency.ada(),
    majorUnits: BigInt.from(majorUnits),
  );
}

Money _usdMajorUnits(int majorUnits) {
  return Money.fromMajorUnits(
    currency: const Currency.usd(),
    majorUnits: BigInt.from(majorUnits),
  );
}

class _FakeVoicesLocalizations extends Fake implements VoicesLocalizations {
  @override
  String get campaignTotalAsk => 'Campaign Total Ask';
  @override
  String get campaignTreasury => 'Campaign Treasury';
  @override
  String get campaignTreasuryDescription => 'Total budget, including ecosystem incentives';
  @override
  String get categoryBudget => 'Category Budget';
  @override
  String get currentAsk => 'Current Ask';
  @override
  String get fundsAvailableForCategory => 'Funds available for this category';
  @override
  String get maximumAsk => 'Maximum Ask';
  @override
  String get minimumAsk => 'MinimumAsk';
}
