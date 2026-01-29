import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_header.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_general_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingHeader extends StatelessWidget {
  const VotingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingHeaderCategoryData?>(
      selector: (state) => state.selectedCategoryHeaderData,
      builder: (context, categoryHeaderData) {
        return categoryHeaderData == null
            ? const VotingGeneralHeader()
            : VotingCategoryHeader(category: categoryHeaderData);
      },
    );
  }
}
