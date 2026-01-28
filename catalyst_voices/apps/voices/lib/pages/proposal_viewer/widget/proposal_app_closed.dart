import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/active_fund_number_selector_ext.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/document_viewer/document_viewer_content.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalAppClosed extends StatefulWidget {
  const ProposalAppClosed({
    super.key,
  });

  @override
  State<ProposalAppClosed> createState() => _ProposalAppClosedState();
}

class _AppCloseText extends StatelessWidget {
  final MainAxisSize mainAxisSize;

  const _AppCloseText({this.mainAxisSize = MainAxisSize.min});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      spacing: 16,
      children: [
        VoicesAvatar(
          icon: VoicesAssets.icons.exclamation.buildIcon(
            color: context.colors.iconsError,
          ),
          backgroundColor: context.colors.onSurfaceError08,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.catalystAppClosed,
                style: context.textTheme.titleMedium,
              ),
              Text(
                context.l10n.browseProposalsOnProjectCatalyst(context.activeCampaignFundNumber),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textOnPrimaryLevel1,
                ),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget with LaunchUrlMixin {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      trailing: VoicesAssets.icons.externalLink.buildIcon(),
      child: Text(
        context.l10n.browseFundProposals(context.activeCampaignFundNumber),
      ),
      onTap: () async {
        await launchUri(
          VoicesConstants.projectCatalystFundUrl(context.activeCampaignFundNumber).getUri(),
        );
      },
    );
  }
}

class _ProposalAppClosedState extends State<ProposalAppClosed> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentViewerCubit, DocumentViewerState, bool>(
      selector: (state) {
        return state.readOnlyMode;
      },
      builder: (context, readOnlyMode) {
        return Offstage(
          offstage: !readOnlyMode || _opacity == 0,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 200),
            child: ResponsiveBuilder<double>(
              xs: 0,
              sm: 16,
              md: 32,
              lg: 56,
              builder: (context, spacing) => Padding(
                padding: EdgeInsets.only(left: spacing / 2, right: spacing, top: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.colors.elevationsOnSurfaceNeutralLv0,
                  ),
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child: ResponsiveChildBuilder(
                    xs: (context) => const _SmallView(),
                    sm: (context) => const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        Expanded(child: _AppCloseText()),
                        _Button(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final element = notification.context as Element?;

      // Only react to content scroll from ProposalContent, not menu
      if (element?.findAncestorWidgetOfExactType<DocumentViewerContent>() != null) {
        final metrics = notification.metrics;

        const fadeDistance = 75.0;
        final scrollOffset = metrics.extentBefore;
        final newOpacity = (1.0 - (scrollOffset / fadeDistance)).clamp(0.0, 1.0);

        if ((_opacity - newOpacity).abs() > 0.01) {
          setState(() {
            _opacity = newOpacity;
          });
        }
      }
    }
  }
}

class _SmallView extends StatelessWidget {
  const _SmallView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        _AppCloseText(mainAxisSize: MainAxisSize.max),
        SizedBox(
          width: double.infinity,
          child: _Button(),
        ),
      ],
    );
  }
}
