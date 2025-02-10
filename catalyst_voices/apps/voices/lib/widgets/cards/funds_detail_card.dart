import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/amount_formatter.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum FundsDetailCardType {
  found,
  category;

  String localizedTypeName(VoicesLocalizations l10n) {
    return switch (this) {
      FundsDetailCardType.found => l10n.campaignTreasury,
      FundsDetailCardType.category => l10n.categoryBudget,
    };
  }

  String localizedTotalAsk(VoicesLocalizations l10n) {
    return switch (this) {
      FundsDetailCardType.found => l10n.campaignTotalAsk,
      FundsDetailCardType.category => l10n.currentAsk,
    };
  }

  String localizedTypeDescription(VoicesLocalizations l10n) {
    return switch (this) {
      FundsDetailCardType.found => l10n.campaignTreasuryDescription,
      FundsDetailCardType.category => l10n.fundsAvailableForCategory,
    };
  }
}

class FundsDetailCard extends StatelessWidget {
  final int allFunds;
  final int totalAsk;
  final Range<int> askRange;
  final FundsDetailCardType type;

  const FundsDetailCard({
    super.key,
    required this.allFunds,
    required this.totalAsk,
    required this.askRange,
    this.type = FundsDetailCardType.found,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outlineBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          VoicesAssets.icons.library.buildIcon(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10,
              runSpacing: 10,
              children: [
                _CampaignFundsDetail(
                  title: type.localizedTypeName(context.l10n),
                  description: type.localizedTypeDescription(context.l10n),
                  funds: allFunds,
                ),
                _CampaignFundsDetail(
                  title: type.localizedTotalAsk(context.l10n),
                  description: context.l10n.campaignTotalAskDescription,
                  funds: totalAsk,
                  largeFundsText: false,
                ),
                _RangeAsk(range: askRange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignFundsDetail extends StatelessWidget {
  final String title;
  final String description;
  final int funds;
  final bool largeFundsText;

  const _CampaignFundsDetail({
    required this.title,
    required this.description,
    required this.funds,
    this.largeFundsText = true,
  });

  String get _formattedFunds => AmountFormatter.decimalFormat(funds);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Skeleton.keep(
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        ),
        Skeleton.keep(
          child: Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.sysColorsNeutralN60,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${const Currency.ada().symbol} $_formattedFunds',
          style: _foundsTextStyle(context)?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }

  TextStyle? _foundsTextStyle(BuildContext context) {
    if (largeFundsText) {
      return context.textTheme.headlineLarge;
    } else {
      return context.textTheme.headlineSmall;
    }
  }
}

class _RangeAsk extends StatelessWidget {
  final Range<int> range;

  const _RangeAsk({
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: context.colors.outlineBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RangeValue(
            title: context.l10n.maximumAsk,
            value: range.max ?? 0,
          ),
          const SizedBox(height: 19),
          _RangeValue(
            title: context.l10n.minimumAsk,
            value: range.min ?? 0,
          ),
        ],
      ),
    );
  }
}

class _RangeValue extends StatelessWidget {
  final String title;
  final int value;

  const _RangeValue({
    required this.title,
    required this.value,
  });

  String get _formattedValue => AmountFormatter.decimalFormat(value);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Skeleton.keep(
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.sysColorsNeutralN60,
            ),
          ),
        ),
        Text(
          '${const Currency.ada().symbol} $_formattedValue',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.sysColorsNeutralN60,
          ),
        ),
      ],
    );
  }
}
