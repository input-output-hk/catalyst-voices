import 'package:catalyst_voices/pages/remote_widgets/remote_form.dart';
import 'package:flutter/material.dart';

final class RemoteWidgetsPage extends StatelessWidget {
  const RemoteWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RemoteForm(),
      ),
    );
  }
}
