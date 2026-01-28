part of '../proposal_builder_segments.dart';

class _CollaboratorsDetailsAction extends StatelessWidget {
  final bool isEditMode;
  final ValueChanged<EditableTileChange> onChanged;

  const _CollaboratorsDetailsAction({
    required this.isEditMode,
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
          final change = (
            isEditMode: !isEditMode,
            source: EditableTileChangeSource.cancel,
          );
          onChanged(change);
        },
        isEditing: isEditMode,
      ),
    );
  }
}
