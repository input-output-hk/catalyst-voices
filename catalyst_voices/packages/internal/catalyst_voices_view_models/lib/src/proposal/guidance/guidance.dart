import 'package:catalyst_voices_view_models/src/proposal/guidance/guidance_type.dart';
import 'package:equatable/equatable.dart';

final class Guidance extends Equatable implements Comparable<Guidance> {
  final String title;
  final String description;
  final GuidanceType type;
  final int? weight; // This represents how important the guidance is in
  //specific [GuidanceType].

  const Guidance({
    required this.title,
    required this.description,
    required this.type,
    this.weight,
  });

  String get weightText => weight?.toString() ?? '';

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
        title,
        description,
        type,
      ];
}

extension GuidanceExt on List<Guidance> {
  List<Guidance> sortedByWeight() {
    return [...this]..sort();
  }
}
