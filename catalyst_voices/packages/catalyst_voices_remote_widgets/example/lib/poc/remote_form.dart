import 'package:catalyst_voices/pages/remote_widgets/temp.dart';
import 'package:flutter/material.dart';

class RemoteForm extends StatefulWidget {
  const RemoteForm({super.key});

  @override
  State<RemoteForm> createState() => _RemoteFormState();
}

class _RemoteFormState extends State<RemoteForm> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 500,
      child: NetworkExample(),
    );
  }
}
