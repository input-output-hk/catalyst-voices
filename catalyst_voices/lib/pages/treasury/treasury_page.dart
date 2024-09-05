import 'package:flutter/material.dart';

class TreasuryPage extends StatelessWidget {
  const TreasuryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      child: Text(
        'Treasury',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
