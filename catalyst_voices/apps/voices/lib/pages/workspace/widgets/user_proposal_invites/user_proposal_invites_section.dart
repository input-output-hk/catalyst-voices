import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/widgets/user_proposals/user_proposal_section.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/images/voices_image_scheme.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class UserProposalInvitesSection extends StatelessWidget {
  const UserProposalInvitesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, UserProposalsView>(
      selector: (state) {
        return state.userProposalInvites.userProposalInvites;
      },
      builder: (context, invites) {
        return _PendingProposalInvites(invites: invites);
      },
    );
  }
}

class _EmptyProposalInvites extends StatelessWidget {
  const _EmptyProposalInvites();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: EmptyState(
        title: Text(context.l10n.noPendingInvitesMessage),
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
    );
  }
}

class _PendingProposalInvites extends StatelessWidget {
  final UserProposalsView invites;

  const _PendingProposalInvites({required this.invites});

  @override
  Widget build(BuildContext context) {
    if (invites.items.isEmpty) {
      return const _EmptyProposalInvites();
    }

    // TODO(LynxLynxx): Update this to proper Invites section
    return UserProposalSection(
      items: invites.items,
      emptyTextMessage: '',
      title: context.l10n.notActiveCampaign,
      info: context.l10n.notActiveCampaignInfoMarkdown,
    );
  }
}
