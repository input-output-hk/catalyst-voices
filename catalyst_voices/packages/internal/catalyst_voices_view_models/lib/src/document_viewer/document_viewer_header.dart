import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class DocumentViewerHeader extends Equatable {
  final DocumentRef? documentRef;
  final String title;
  final DateTime? createdAt;
  final List<DocumentVersion> versions;
  final bool isFavorite;

  const DocumentViewerHeader({
    this.documentRef,
    this.title = '',
    this.createdAt,
    this.versions = const <DocumentVersion>[],
    this.isFavorite = false,
  });

  DocumentViewerHeader copyWith({
    Optional<DocumentRef>? documentRef,
    String? title,
    Optional<DateTime>? createdAt,
    List<DocumentVersion>? versions,
    bool? isFavorite,
  }) {
    return DocumentViewerHeader(
      documentRef: documentRef.dataOr(this.documentRef),
      title: title ?? this.title,
      createdAt: createdAt.dataOr(this.createdAt),
      versions: versions ?? this.versions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    documentRef,
    title,
    createdAt,
    versions,
    isFavorite,
  ];
}
