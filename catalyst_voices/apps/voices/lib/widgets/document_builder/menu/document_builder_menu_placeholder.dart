import 'package:catalyst_voices/widgets/menu/voices_node_menu_placeholder.dart';
import 'package:flutter/material.dart';

class DocumentBuilderMenuPlaceholder extends StatelessWidget {
  const DocumentBuilderMenuPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const VoicesNodeMenuPlaceholder(
          isExpanded: true,
          childrenCount: 2,
        ),
        for (int i = 0; i < 8; i++) const VoicesNodeMenuPlaceholder(),
      ],
    );
  }
}
