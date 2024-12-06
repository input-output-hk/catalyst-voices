import 'dart:core';

import 'package:equatable/equatable.dart';

enum GuidanceType {
  mandatory(priority: 0),
  education(priority: 1),
  tips(priority: 2);

  final int priority;

  const GuidanceType({
    required this.priority,
  });
}

final class Guidance extends Equatable implements Comparable<Guidance> {
  final String id;
  final String title;
  final String description;
  final GuidanceType type;

  /// This represents how important the guidance is in specific [GuidanceType].
  final int? weight;

  const Guidance({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.weight,
  });

  @override
  int compareTo(Guidance other) {
    final typeComparison = type.priority.compareTo(other.type.priority);
    if (typeComparison != 0) {
      return typeComparison;
    }
    if (weight == null && other.weight == null) return 0;
    if (weight == null) return 1;
    if (other.weight == null) return -1;
    return weight!.compareTo(other.weight!);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        weight,
      ];
}

extension GuidanceExt on List<Guidance> {
  List<Guidance> sortedByWeight() {
    return [...this]..sort();
  }
}
