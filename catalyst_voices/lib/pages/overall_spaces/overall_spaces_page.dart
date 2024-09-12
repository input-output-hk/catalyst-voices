import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OverallSpacesPage extends StatelessWidget {
  const OverallSpacesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(),
      body: Center(child: Text('Overall spaces')),
    );
  }
}
