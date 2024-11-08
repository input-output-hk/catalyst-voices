import 'package:catalyst_voices_view_models/src/proposal/guidance/guidance_type.dart';
import 'package:equatable/equatable.dart';

final class Guidance extends Equatable {
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
  List<Object?> get props => [
        title,
        description,
        type,
      ];
}

extension GuidanceExt on List<Guidance> {
  List<Guidance> sortedByWeight() {
    return [...this]..sort((a, b) {
        final typeComparison = a.type.priority.compareTo(b.type.priority);
        if (typeComparison != 0) {
          return typeComparison;
        }
        if (a.weight == null && b.weight == null) return 0;
        if (a.weight == null) return 1;
        if (b.weight == null) return -1;
        return a.weight!.compareTo(b.weight!);
      });
  }
}
