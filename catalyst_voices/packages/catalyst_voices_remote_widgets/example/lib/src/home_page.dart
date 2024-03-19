// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:remote_widgets_example/src/remote_form.dart';
import 'package:remote_widgets_example/src/widgets/local_widget.dart';
import 'package:remote_widgets_example/src/widgets/new_local_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Widgets Example'),
      ),
      body: const Center(
        child: RemoteForm(),
        // child: LocalWidget(),
        // child: NewLocalWidgets(),
      ),
    );
  }
}
