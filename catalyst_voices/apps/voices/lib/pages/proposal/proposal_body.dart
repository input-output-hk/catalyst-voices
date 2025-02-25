import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProposalBody extends StatelessWidget {
  const ProposalBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceScaffold(
      left: Center(child: Text('Left')),
      body: ColoredBox(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Start'),
            SizedBox(height: 1200),
            Text('End'),
          ],
        ),
      ),
      right: Offstage(),
    );
  }
}
