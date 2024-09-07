import 'package:flutter/material.dart';

class FundedProjectsPage extends StatelessWidget {
  const FundedProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent,
      alignment: Alignment.center,
      child: Text(
        'Funded Projects',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
