import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// A left menu for the document builder with the segments (sections / properties).
class DocumentBuilderSegmentsMenu extends StatelessWidget {
  final SegmentsController controller;

  const DocumentBuilderSegmentsMenu({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentsMenuListener(controller: controller);
  }
}
