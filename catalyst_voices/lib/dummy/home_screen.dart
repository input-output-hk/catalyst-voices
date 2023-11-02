import 'package:catalyst_voices/dummy/poc.dart';
import 'package:flutter/material.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      key: WidgetKeys.homeScreen,
      body: Center(
        child: Text('Catalyst Voices'),
      ),
    );
  }
}
