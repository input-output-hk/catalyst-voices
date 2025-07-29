import 'package:flutter/material.dart';

class VotingListBallot extends StatelessWidget {
  const VotingListBallot({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 20,
      itemBuilder: (context, index) {},
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }
}
