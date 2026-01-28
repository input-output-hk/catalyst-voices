import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Base state for document viewers.
/// Shared across all document types.
class DocumentViewerState<Data extends DocumentViewerData> extends Equatable {
  final bool isLoading;
  final Data data;
  final LocalizedException? error;

  const DocumentViewerState({
    this.isLoading = false,
    required this.data,
    this.error,
  });

  @override
  List<Object?> get props => [isLoading, data, error];

  bool get showData => !showError;
  bool get showError => !isLoading && error != null;

  DocumentViewerState copyWith({
    bool? isLoading,
    Data? data,
    Optional<LocalizedException>? error,
    bool? readOnlyMode,
  }) {
    return DocumentViewerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error.dataOr(this.error),
    );
  }
}
