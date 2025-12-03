part of '../proposal_builder_segments.dart';

class _CollaboratorsDetailsAction extends StatelessWidget {
  final DocumentProperty property;
  final ValueChanged<EditableTileChange> onChanged;

  const _CollaboratorsDetailsAction({
    required this.property,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CombineSemantics(
      identifier: 'EditableTileEditCancelButton',
      child: VoicesEditCancelButton(
        key: const Key('EditableTileEditCancelButton'),
        style: VoicesEditCancelButtonStyle.outlinedWithIcon,
        onTap: () {
          final sectionTileData = _getTileData(context);
          final isEditMode = !sectionTileData.isEditMode;
          final change = (
            isEditMode: isEditMode,
            source: EditableTileChangeSource.cancel,
          );
          onChanged(change);
          if (!isEditMode) {
            final dataNodeId = _CollaboratorsDetailsSelector.getDataNodeId(property.nodeId);
            DocumentBuilderSectionTileControllerScope.of(context).removeData(dataNodeId);
          }
        },
        isEditing: _getTileData(context).isEditMode,
      ),
    );
  }

  DocumentBuilderSectionTileData _getTileData(BuildContext context) {
    return DocumentBuilderSectionTileControllerScope.of(
          context,
        ).getData<DocumentBuilderSectionTileData>(property.nodeId) ??
        DocumentBuilderSectionTileData(
          isEditMode: false,
          editedSection: property,
          builder: property.toBuilder(),
          pendingChanges: List.empty(growable: true),
        );
  }
}
