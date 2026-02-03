import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_bottom_sheet.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_footer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingListPage extends StatefulWidget {
  const VotingListPage({super.key});

  @override
  State<VotingListPage> createState() => _VotingListPageState();
}

class _VotingListPageState extends State<VotingListPage>
    with SignalHandlerStateMixin<VotingBallotBloc, VotingBallotSignal, VotingListPage> {
  final _bottomSheetController = BottomSheetContainerController();

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      bottomSheet: const VotingListBottomSheet(),
      controller: _bottomSheetController,
      child: const Column(
        children: [
          Expanded(child: VotingList()),
          VotingListFooter(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  void handleSignal(VotingBallotSignal signal) {
    switch (signal) {
      case HideBottomSheetSignal():
        _bottomSheetController.hide();
      case ShowBottomSheetSignal():
        _bottomSheetController.show();
    }
  }
}
