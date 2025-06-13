import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String data;
  final int trimLines;

  const ExpandableText(
    this.data, {
    super.key,
    required this.trimLines,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.data);
  }
}
