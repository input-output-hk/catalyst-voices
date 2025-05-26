import 'package:flutter/material.dart';

class BuildNumberText extends StatefulWidget {
  final String? data;

  const BuildNumberText(
    this.data, {
    super.key,
  });

  @override
  State<BuildNumberText> createState() => _BuildNumberTextState();
}

class _BuildNumberTextState extends State<BuildNumberText> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer(widget.data ?? '-');

    final dateTime = _dateTime;
    if (dateTime != null) {
      buffer.write(' -> DateTime[${dateTime.toIso8601String()}]');
    }

    return Text(buffer.toString());
  }

  @override
  void didUpdateWidget(BuildNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data) {
      _dateTime = _tryParsingAsDateTime();
    }
  }

  @override
  void initState() {
    super.initState();
    _dateTime = _tryParsingAsDateTime();
  }

  DateTime? _tryParsingAsDateTime() {
    final seconds = int.tryParse(widget.data ?? '');
    // one is default value from pubspec.yaml
    if (seconds == null || seconds == 1) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }
}
