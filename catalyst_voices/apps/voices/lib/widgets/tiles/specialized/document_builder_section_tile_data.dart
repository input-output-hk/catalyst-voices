import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentBuilderSectionTileData extends Equatable {
  final bool isEditMode;
  final DocumentProperty editedSection;
  final DocumentPropertyBuilder builder;
  final List<DocumentChange> pendingChanges;

  const DocumentBuilderSectionTileData({
    required this.isEditMode,
    required this.editedSection,
    required this.builder,
    required this.pendingChanges,
  });

  @override
  List<Object?> get props => [isEditMode, editedSection, builder, pendingChanges];

  DocumentBuilderSectionTileData copyWith({
    bool? isEditMode,
    DocumentProperty? editedSection,
    DocumentPropertyBuilder? builder,
    List<DocumentChange>? pendingChanges,
  }) {
    return DocumentBuilderSectionTileData(
      isEditMode: isEditMode ?? this.isEditMode,
      editedSection: editedSection ?? this.editedSection,
      builder: builder ?? this.builder,
      pendingChanges: pendingChanges ?? this.pendingChanges,
    );
  }
}
