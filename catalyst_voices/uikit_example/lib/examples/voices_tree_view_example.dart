import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesTreeViewExample extends StatelessWidget {
  static const String route = '/tree-view-example';

  const VoicesTreeViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TreeView')),
      body: const Column(
        children: [
          SimpleTreeView(
            isExpanded: true,
            root: SimpleTreeViewRootRow(
              leading: [
                Icon(Icons.check_box_outline_blank_rounded),
                Icon(Icons.grid_view_rounded),
              ],
              child: Text('Problem-sensing stage'),
            ),
            children: [
              SimpleTreeViewChildRow(
                isSelected: true,
                child: Text('Start'),
              ),
              SimpleTreeViewChildRow(child: Text('Vote')),
              SimpleTreeViewChildRow(
                hasNext: false,
                child: Text('Results'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
