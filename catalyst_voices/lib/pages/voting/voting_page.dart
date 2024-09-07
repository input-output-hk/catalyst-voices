import 'package:flutter/material.dart';

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      alignment: Alignment.center,
      child: Text(
        'Voting',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
