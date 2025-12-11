import 'package:equatable/equatable.dart';

final class DocumentsSyncResult extends Equatable {
  final int newDocumentsCount;
  final int failedDocumentsCount;

  const DocumentsSyncResult({
    this.newDocumentsCount = 0,
    this.failedDocumentsCount = 0,
  });

  @override
  List<Object?> get props => [
    newDocumentsCount,
    failedDocumentsCount,
  ];

  DocumentsSyncResult operator +(DocumentsSyncResult other) {
    return DocumentsSyncResult(
      newDocumentsCount: newDocumentsCount + other.newDocumentsCount,
      failedDocumentsCount: failedDocumentsCount + other.failedDocumentsCount,
    );
  }
}
