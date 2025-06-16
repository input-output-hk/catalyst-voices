import 'package:catalyst_voices/widgets/gesture/voices_gesture_detector.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String data;
  final int trimLines;

  const ExpandableText(
    this.data, {
    required super.key,
    required this.trimLines,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // '…'
        Text(
          widget.data,
          maxLines: _isExpanded ? null : widget.trimLines,
          overflow: _isExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        VoicesGestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Show less' : 'Show more',
          ),
        ),
      ],
    );
  }
}
