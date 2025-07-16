import 'package:catalyst_voices/widgets/widgets.dart';
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
            const VoicesTabBar(
              tabs: [
                VoicesTab(data: 'sections', child: VoicesTabText('Sections')),
                VoicesTab(data: 'comments', child: VoicesTabText('Comments')),
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
