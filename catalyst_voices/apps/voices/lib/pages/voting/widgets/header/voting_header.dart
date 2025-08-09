import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_header.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_general_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingHeader extends StatelessWidget {
  const VotingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, CampaignCategoryDetailsViewModel?>(
      selector: (state) => state.selectedCategory,
      builder: (context, category) {
        if (category == null) {
          return const VotingGeneralHeader();
        } else {
          return VotingCategoryHeader(category: category);
        }
      },
    );
  }
}
