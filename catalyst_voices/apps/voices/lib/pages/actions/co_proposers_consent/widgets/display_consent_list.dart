import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/widgets/proposal_display_consent_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_decorated_sliver_panel.dart';
import 'package:catalyst_voices/routes/routing/proposal_route.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/images/voices_image_scheme.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DisplayConsentList extends StatelessWidget {
  const DisplayConsentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionsDecoratedSliverPanel(
      sliver: BlocSelector<DisplayConsentCubit, DisplayConsentState, ProposalsDisplayConsent>(
        selector: (state) {
          return state.consents;
        },
        builder: (context, consents) {
          if (consents.items.isEmpty) {
            return const _EmptyState();
          }
          return SliverList.separated(
            itemCount: consents.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = consents.items[index];

              return ProposalDisplayConsentCard(
                key: ValueKey(item.id),
                proposalDisplayConsent: item,

                onTap: () => ProposalRoute.fromRef(ref: item.id).go(context),
                onSelected: (value) {
                  unawaited(
                    context.read<DisplayConsentCubit>().changeDisplayConsent(
                      id: item.id,
                      displayConsentStatus: value,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        child: EmptyState(
          key: const Key('DisplayConsentEmpty'),
          title: Text(context.l10n.noInvitesYet),
          description: Text(context.l10n.noInvitesYetDescription),
          image: VoicesImagesScheme(
            image: VoicesAssets.images.svg.noProposalForeground.buildPicture(),
            background: Container(
              height: 180,
              decoration: BoxDecoration(
                color: context.colors.onSurfaceNeutral08,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
