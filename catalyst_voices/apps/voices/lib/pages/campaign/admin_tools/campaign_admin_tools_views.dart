import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The "views" tab of the [CampaignAdminToolsDialog].
class CampaignAdminToolsViewsTab extends StatefulWidget {
  const CampaignAdminToolsViewsTab({super.key});

  @override
  State<CampaignAdminToolsViewsTab> createState() =>
      _CampaignAdminToolsViewsTabState();
}

class _CampaignAdminToolsViewsTabState
    extends State<CampaignAdminToolsViewsTab> {
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
            BlocBuilder<AdminToolsCubit, AdminToolsState>(
              builder: (context, state) {
                return VoicesSegmentedButton<AuthenticationStatus>(
                  segments: [
                    for (final userState in AuthenticationStatus.values)
                      ButtonSegment(
                        value: userState,
                        label: Text(userState.name(context.l10n)),
                      ),
                  ],
                  selected: {state.authStatus},
                  onChanged: (selected) {
                    context
                        .read<AdminToolsCubit>()
                        .updateAuthStatus(selected.first);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension _AuthenticationStatusExt on AuthenticationStatus {
  String name(VoicesLocalizations l10n) {
    return switch (this) {
      AuthenticationStatus.actor => l10n.actor,
      AuthenticationStatus.guest => l10n.guest,
      AuthenticationStatus.visitor => l10n.visitor,
    };
  }
}
