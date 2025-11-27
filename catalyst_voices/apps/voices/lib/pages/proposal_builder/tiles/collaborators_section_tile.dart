import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/co_proposers/widgets/add_collaborator/add_collaborator_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CollaboratorsSectionTile extends StatefulWidget {
  final CollaboratorsSection section;
  final bool isSelected;

  const CollaboratorsSectionTile({
    super.key,
    required this.section,
    required this.isSelected,
  });

  @override
  State<CollaboratorsSectionTile> createState() => _CollaboratorsSectionTileState();
}

class _CollaboratorEditItem extends StatelessWidget {
  final CatalystId collaborator;
  final VoidCallback onRemove;

  const _CollaboratorEditItem({
    required this.collaborator,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = collaborator.username ?? context.l10n.anonymousUsername;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: VoicesAssets.icons.x.buildIcon(
              size: 18,
              color: context.colorScheme.primary,
            ),
            onPressed: onRemove,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          VoicesAvatar(
            icon: Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
              style: context.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    displayName,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colors.textOnPrimaryLevel1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CatalystIdText(
                  collaborator,
                  isCompact: true,
                  showCopy: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollaboratorReadItem extends StatelessWidget {
  final CatalystId collaborator;

  const _CollaboratorReadItem({
    required this.collaborator,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = collaborator.username ?? context.l10n.anonymousUsername;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          VoicesAvatar(
            icon: Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.iconsOnImage,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    displayName,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colors.textOnPrimaryLevel0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                CatalystIdText(
                  collaborator,
                  isCompact: true,
                  showCopy: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollaboratorsSectionTileState extends State<CollaboratorsSectionTile> {
  late final WidgetStatesController _statesController;
  late List<CatalystId> _editingCollaborators;
  bool _isEditMode = false;

  bool get _canAddMore => _editingCollaborators.length < widget.section.maxCollaborators;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleOnTap,
      child: EditableTile(
        key: ValueKey('CollaboratorsSection[${widget.section.id.value}]Tile'),
        title: widget.section.resolveTitle(context),
        statesController: _statesController,
        isEditMode: _isEditMode,
        isSaveEnabled: true,
        // isEditEnabled: true,
        saveText: context.l10n.saveChangesButtonText,
        // errorText: _errorText,
        saveButtonLeading: VoicesAssets.icons.check.buildIcon(),
        editCancelButtonStyle: VoicesEditCancelButtonStyle.outlinedWithIcon,
        onChanged: _onEditModeChange,
        child: _isEditMode ? _buildEditView(context) : _buildReadOnlyView(context),
      ),
    );
  }

  @override
  void didUpdateWidget(CollaboratorsSectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section != widget.section) {
      _editingCollaborators = List.of(widget.section.collaborators);
    }
    if (widget.isSelected != oldWidget.isSelected) {
      _statesController.update(WidgetState.selected, widget.isSelected);
    }
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController({
      if (widget.isSelected) WidgetState.selected,
    });
    _editingCollaborators = List.of(widget.section.collaborators);
  }

  Future<void> _addCollaborator() async {
    final authorId = widget.section.authorId;
    if (authorId == null) return;

    final result = await AddCollaboratorDialog.show(
      context,
      authorId: authorId,
      collaborators: Collaborators(collaborators: _editingCollaborators),
    );

    if (result != null && mounted) {
      setState(() {
        _editingCollaborators.add(result);
      });
    }
  }

  Widget _buildEditView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.collaboratorsSectionDescription(widget.section.maxCollaborators),
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          context.l10n.coproposers,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 2),
        if (_editingCollaborators.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._editingCollaborators.map((collaborator) {
            return _CollaboratorEditItem(
              collaborator: collaborator,
              onRemove: () => _removeCollaborator(collaborator),
            );
          }),
          const SizedBox(height: 6),
        ],
        if (_canAddMore) ...[
          const SizedBox(height: 6),
          VoicesOutlinedButton(
            onTap: _addCollaborator,
            leading: VoicesAssets.icons.plus.buildIcon(size: 18),
            child: Text(context.l10n.add),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildReadOnlyView(BuildContext context) {
    final collaborators = widget.section.collaborators;

    if (collaborators.isEmpty) {
      return Text(context.l10n.proposalEditorNotAnswered);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: collaborators.map((collaborator) {
        return _CollaboratorReadItem(collaborator: collaborator);
      }).toList(),
    );
  }

  void _handleOnTap() {
    SegmentsControllerScope.of(context).selectSectionStep(
      widget.section.id,
      shouldScroll: false,
    );
  }

  void _onEditModeChange(EditableTileChange value) {
    switch (value.source) {
      case EditableTileChangeSource.cancel:
        if (!value.isEditMode) {
          // Canceling edit mode - reset to original values
          setState(() {
            _editingCollaborators = List.of(widget.section.collaborators);
            _isEditMode = false;
          });
        } else {
          setState(() {
            _isEditMode = value.isEditMode;
          });
          SegmentsControllerScope.of(
            context,
          ).selectSectionStep(widget.section.schema.nodeId, shouldScroll: false);
        }
      case EditableTileChangeSource.save:
        _save();
    }
  }

  void _removeCollaborator(CatalystId collaborator) {
    setState(() {
      _editingCollaborators.removeWhere((e) => e.isSameAs(collaborator));
    });
  }

  void _save() {
    context.read<ProposalBuilderBloc>().add(
      UpdateCollaboratorsEvent(
        collaborators: List.of(_editingCollaborators),
      ),
    );
    setState(() {
      _isEditMode = false;
    });
  }
}
