import 'package:catalyst_voices/widgets/common/tab_bar_stack_view.dart';
import 'package:flutter/material.dart';

class VoicesTabsExample extends StatelessWidget {
  static const String route = '/tabs-example';

  const VoicesTabsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabs')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Sections'),
                Tab(text: 'Comments'),
              ],
            ),
            Expanded(
              child: TabBarStackView(
                children: [
                  Container(color: Colors.red),
                  Container(color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
