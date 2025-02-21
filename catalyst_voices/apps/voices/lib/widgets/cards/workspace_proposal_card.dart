import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/text/last_edit_date.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class WorkspaceProposalCard extends StatelessWidget {
  final bool isSubmitted;
  const WorkspaceProposalCard({
    super.key,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return _ProposalSubmitState(
      isSubmitted: isSubmitted,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSubmitted
                ? context.colors.iconsPrimary
                : context.colors.elevationsOnSurfaceNeutralLv1White,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Body(),
              Offstage(
                offstage: isSubmitted,
                child: const _ProposalIterationHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final isSubmitted = _ProposalSubmitState.of(context)?.isSubmitted ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BodyHeader(
          title: 'Latest proposal that is making its rounds.',
          lastUpdate: DateTime.now(),
        ),
        const _CampaignData(
          leadValue: 'Cardano Use Cases: Concept',
          subValue: 'Fund 14 Category',
        ),
        const _CampaignData(
          leadValue: '₳50,000',
          subValue: 'Funding Requested',
        ),
        const _CampaignData(
          leadValue: '7',
          subValue: 'Comments',
        ),
        VoicesIconButton(
          onTap: () {},
          style: IconButton.styleFrom(
            foregroundColor:
                isSubmitted ? context.colors.textOnPrimaryWhite : null,
          ),
          child: VoicesAssets.icons.dotsVertical.buildIcon(),
        ),
      ],
    );
  }
}

class _BodyHeader extends StatelessWidget {
  final String title;
  final DateTime lastUpdate;
  const _BodyHeader({
    required this.title,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = _ProposalSubmitState.of(context)?.headerColor(context);
    final labelColor =
        _ProposalSubmitState.of(context)?.headerLabelColor(context);
    return Column(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            color: headerColor,
          ),
        ),
        LastEditDate(
          dateTime: lastUpdate,
          showTimezone: false,
          textStyle: context.textTheme.labelMedium?.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _CampaignData extends StatelessWidget {
  final String leadValue;
  final String subValue;
  const _CampaignData({
    required this.leadValue,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = _ProposalSubmitState.of(context)?.headerColor(context);
    final labelColor =
        _ProposalSubmitState.of(context)?.headerLabelColor(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          leadValue,
          style: context.textTheme.titleSmall?.copyWith(
            color: headerColor,
          ),
        ),
        Text(
          subValue,
          style: context.textTheme.labelMedium?.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _ProposalIterationHistory extends StatelessWidget {
  const _ProposalIterationHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
      width: double.infinity,
      height: 50,
    );
  }
}

class _ProposalSubmitState extends InheritedWidget {
  final bool isSubmitted;

  const _ProposalSubmitState({
    required super.child,
    required this.isSubmitted,
  });

  Color backgroundColor(BuildContext context) => isSubmitted
      ? context.colors.onSurfacePrimary08
      : context.colors.elevationsOnSurfaceNeutralLv1White;

  Color headerColor(BuildContext context) => isSubmitted
      ? context.colors.textOnPrimaryWhite
      : context.colors.textOnPrimaryLevel0;

  Color headerLabelColor(BuildContext context) => isSubmitted
      ? context.colors.textOnPrimaryWhite
      : context.colors.textOnPrimaryLevel1;

  @override
  bool updateShouldNotify(covariant _ProposalSubmitState oldWidget) {
    if (oldWidget.isSubmitted != isSubmitted) {
      return true;
    }
    return false;
  }

  static _ProposalSubmitState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ProposalSubmitState>();
  }
}
