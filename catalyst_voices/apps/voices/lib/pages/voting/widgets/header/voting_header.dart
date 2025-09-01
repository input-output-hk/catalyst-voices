import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_header.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_general_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingHeader extends StatelessWidget {
  const VotingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingHeaderData>(
      selector: (state) => state.header,
      builder: (context, header) {
        if (header.category == null) {
          return VotingGeneralHeader(showCategoryPicker: header.showCategoryPicker);
        } else {
          return VotingCategoryHeader(category: header.category!);
        }
      },
    );
  }
}
