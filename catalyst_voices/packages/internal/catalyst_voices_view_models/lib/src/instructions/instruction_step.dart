import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class InstructionStep extends Equatable {
  final Widget? prefix;
  final Color? prefixBackgroundColor;
  final Widget? suffix;
  final bool isActive;
  final Widget child;

  const InstructionStep({
    this.prefix,
    this.prefixBackgroundColor,
    this.suffix,
    this.isActive = true,
    required this.child,
  });

  @override
  List<Object?> get props => [prefix, prefixBackgroundColor, child, suffix, isActive];
}
