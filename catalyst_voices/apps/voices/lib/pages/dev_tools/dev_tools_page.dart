import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DevToolsPage extends StatefulWidget {
  const DevToolsPage._();

  @override
  State<DevToolsPage> createState() => _DevToolsPageState();

  static Future<void> show(BuildContext context) {
    final route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: const DevToolsPage._(),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      settings: const RouteSettings(name: '/dev-tools'),
    );

    return Navigator.push(context, route);
  }
}

class _DevToolsPageState extends State<DevToolsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: VoicesAppBar(),
      body: SizedBox.expand(child: Placeholder(child: Center(child: Text('DevTools')))),
    );
  }
}
