import 'package:equatable/equatable.dart';

/// Represents a document version. Allows tracking multiple versions of a document.
///
// Note. Later we may want to add status enum.
final class DocumentVersion extends Equatable {
  static const int firstNumber = 1;

  final String id;
  final int number;
  final bool isCurrent;
  final bool isLatest;

  const DocumentVersion({
    required this.id,
    required this.number,
    this.isCurrent = false,
    this.isLatest = false,
  });

  @override
  List<Object?> get props => [
        id,
        number,
        isCurrent,
        isLatest,
      ];

  DocumentVersion copyWith({
    String? id,
    int? number,
    bool? isCurrent,
    bool? isLatest,
  }) {
    return DocumentVersion(
      id: id ?? this.id,
      number: number ?? this.number,
      isCurrent: isCurrent ?? this.isCurrent,
      isLatest: isLatest ?? this.isLatest,
    );
  }
}
