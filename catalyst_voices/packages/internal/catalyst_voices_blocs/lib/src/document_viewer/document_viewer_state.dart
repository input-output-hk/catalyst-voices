import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Base view data for document viewers.
/// Contains common fields like header and segments.
class DocumentViewData extends Equatable {
  final DocumentViewHeader header;
  final List<Segment> segments;

  const DocumentViewData({
    this.header = const DocumentViewHeader(),
    this.segments = const [],
  });

  @override
  List<Object?> get props => [header, segments];

  DocumentViewData copyWith({
    DocumentViewHeader? header,
    List<Segment>? segments,
  }) {
    return DocumentViewData(
      header: header ?? this.header,
      segments: segments ?? this.segments,
    );
  }
}

/// Base state for document viewers.
/// Shared across all document types.
class DocumentViewerState extends Equatable {
  final bool isLoading;
  final DocumentViewData data;
  final LocalizedException? error;
  final bool readOnlyMode;

  const DocumentViewerState({
    this.isLoading = false,
    this.data = const DocumentViewData(),
    this.error,
    this.readOnlyMode = false,
  });

  @override
  List<Object?> get props => [isLoading, data, error, readOnlyMode];

  bool get showData => !showError;
  bool get showError => !isLoading && error != null;

  DocumentViewerState copyWith({
    bool? isLoading,
    DocumentViewData? data,
    Optional<LocalizedException>? error,
    bool? readOnlyMode,
  }) {
    return DocumentViewerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error.dataOr(this.error),
      readOnlyMode: readOnlyMode ?? this.readOnlyMode,
    );
  }
}

/// Base header for document views.
/// Common metadata like title, author, etc.
class DocumentViewHeader extends Equatable {
  final String title;
  final String? authorName;
  final DateTime? createdAt;
  final int? commentsCount; // Optional for reuse

  const DocumentViewHeader({
    this.title = '',
    this.authorName,
    this.createdAt,
    this.commentsCount,
  });

  @override
  List<Object?> get props => [title, authorName, createdAt, commentsCount];

  DocumentViewHeader copyWith({
    String? title,
    String? authorName,
    DateTime? createdAt,
    int? commentsCount,
  }) {
    return DocumentViewHeader(
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
