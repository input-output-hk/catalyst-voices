import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// View model for document lookup tile data.
final class DocumentLookupTileData extends Equatable {
  final DocumentRef ref;
  final String metadata;
  final String content;

  const DocumentLookupTileData({
    required this.ref,
    required this.metadata,
    required this.content,
  });

  @override
  List<Object?> get props => [ref, metadata, content];
}
