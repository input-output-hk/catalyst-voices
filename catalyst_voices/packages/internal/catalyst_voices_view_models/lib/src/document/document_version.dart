import 'package:equatable/equatable.dart';

// Note. Later we may want to add status enum.
final class DocumentVersion extends Equatable {
  final String id;
  final int nr;
  final bool isCurrent;
  final bool isLatest;

  const DocumentVersion({
    required this.id,
    required this.nr,
    this.isCurrent = false,
    this.isLatest = false,
  });

  @override
  List<Object?> get props => [
        id,
        nr,
        isCurrent,
        isLatest,
      ];
}
