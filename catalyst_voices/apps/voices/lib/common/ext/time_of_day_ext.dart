import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  String get formatted {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
