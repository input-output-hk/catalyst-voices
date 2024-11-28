import 'package:catalyst_voices/widgets/modals/details/voices_details_dialog_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignHeader extends StatelessWidget {
  const CampaignHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignDetailsBloc, CampaignDetailsState, String?>(
      selector: (state) => state.title,
      builder: (context, state) {
        return VoicesDetailsDialogHeader(
          title: state ?? '',
          titleLabel: context.l10n.campaign,
        );
      },
    );
  }
}
