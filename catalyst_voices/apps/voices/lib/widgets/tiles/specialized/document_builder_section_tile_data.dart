import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentBuilderSectionTileData extends Equatable {
  final bool isEditMode;
  final DocumentProperty editedSection;
  final DocumentPropertyBuilder builder;
  final List<DocumentChange> pendingDocumentChanges;

  /// `null` - there is no user changes - already saved list of collaborators should be used.
  /// `empty` - user has deleted all collaborators and wants to save it.
  /// `non-empty` - user has changed collaborators and wants to save it.
  final List<CatalystId>? pendingCollaboratorsChanges;

  const DocumentBuilderSectionTileData({
    required this.isEditMode,
    required this.editedSection,
    required this.builder,
    required this.pendingDocumentChanges,
    required this.pendingCollaboratorsChanges,
  });

  @override
  List<Object?> get props => [
    isEditMode,
    editedSection,
    builder,
    pendingDocumentChanges,
    pendingCollaboratorsChanges,
  ];

  DocumentBuilderSectionTileData copyWith({
    bool? isEditMode,
    DocumentProperty? editedSection,
    DocumentPropertyBuilder? builder,
    List<DocumentChange>? pendingDocumentChanges,
    Optional<List<CatalystId>>? pendingCollaboratorsChanges,
  }) {
    return DocumentBuilderSectionTileData(
      isEditMode: isEditMode ?? this.isEditMode,
      editedSection: editedSection ?? this.editedSection,
      builder: builder ?? this.builder,
      pendingDocumentChanges: pendingDocumentChanges ?? this.pendingDocumentChanges,
      pendingCollaboratorsChanges: pendingCollaboratorsChanges.dataOr(
        this.pendingCollaboratorsChanges,
      ),
    );
  }
}
