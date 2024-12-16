import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The "views" tab of the [CampaignAdminToolsDialog].
class CampaignAdminToolsViewsTab extends StatelessWidget {
  const CampaignAdminToolsViewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.userAuthenticationState,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            const _SessionStatus(),
          ],
        ),
      ),
    );
  }
}

class _SessionStatus extends StatelessWidget {
  const _SessionStatus();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AdminToolsCubit, AdminToolsState, SessionStatus>(
      selector: (state) => state.sessionStatus,
      builder: (context, sessionStatus) {
        return VoicesSegmentedButton<SessionStatus>(
          segments: [
            for (final userState in SessionStatus.values)
              ButtonSegment(
                value: userState,
                label: Text(userState.name(context.l10n)),
              ),
          ],
          selected: {sessionStatus},
          onChanged: (selected) {
            context.read<AdminToolsCubit>().updateSessionStatus(selected.first);
          },
        );
      },
    );
  }
}
