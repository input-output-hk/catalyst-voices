part of '../proposal_builder_segments.dart';

typedef CollaboratorsData = ({CatalystId? authorId, List<CatalystId> collaborators});

class _CollaboratorEditItem extends StatelessWidget {
  final CatalystId collaborator;
  final VoidCallback onRemove;

  const _CollaboratorEditItem({
    required this.collaborator,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = collaborator.getDisplayName(context);
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
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
            radius: 16,
            padding: EdgeInsets.zero,
            icon: Text(
              displayName.first?.toUpperCase() ?? '',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.textOnPrimaryLevel0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              displayName,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall?.copyWith(
                color: colors.textOnPrimaryLevel1,
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
    );
  }
}

class _CollaboratorReadItem extends StatelessWidget {
  final CatalystId collaborator;

  const _CollaboratorReadItem(this.collaborator);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          context.l10n.coproposer,
          style: textTheme.labelLarge?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        Row(
          spacing: 8,
          children: [
            Flexible(
              child: Text(
                collaborator.getDisplayName(context),
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textOnPrimaryLevel0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CatalystIdText(
              collaborator,
              isCompact: true,
              showCopy: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _CollaboratorsDetails extends StatelessWidget {
  final CollaboratorsData collaboratorsData;
  final CollaboratorsSectionData collaboratorsSectionData;
  final int maxCollaborators;

  const _CollaboratorsDetails({
    required this.collaboratorsData,
    required this.collaboratorsSectionData,
    required this.maxCollaborators,
  });

  @override
  Widget build(BuildContext context) {
    return collaboratorsSectionData.isEditMode
        ? _CollaboratorsEditView(
            authorId: collaboratorsData.authorId,
            collaborators: collaboratorsSectionData.editedData ?? collaboratorsData.collaborators,
            onChanged: collaboratorsSectionData.onCollaboratorsChanged,
            maxCollaborators: maxCollaborators,
          )
        : _CollaboratorsReadOnlyView(collaboratorsData.collaborators);
  }
}

class _CollaboratorsDetailsSelector extends StatelessWidget {
  final CollaboratorsSectionData collaboratorsSectionData;
  final int maxCollaborators;

  const _CollaboratorsDetailsSelector({
    required this.collaboratorsSectionData,
    required this.maxCollaborators,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, CollaboratorsData>(
      selector: (state) => (
        authorId: state.metadata.authorId,
        collaborators: state.metadata.collaborators,
      ),
      builder: (_, data) => _CollaboratorsDetails(
        collaboratorsData: data,
        collaboratorsSectionData: collaboratorsSectionData,
        maxCollaborators: maxCollaborators,
      ),
    );
  }
}

class _CollaboratorsEditView extends StatelessWidget {
  final CatalystId? authorId;
  final List<CatalystId> collaborators;
  final ValueChanged<List<CatalystId>?> onChanged;
  final int maxCollaborators;

  const _CollaboratorsEditView({
    required this.authorId,
    required this.collaborators,
    required this.onChanged,
    required this.maxCollaborators,
  });

  set collaborators(List<CatalystId> value) => onChanged(value);

  bool get _canAddMore => collaborators.length < maxCollaborators;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.collaboratorsSectionDescription(maxCollaborators),
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          context.l10n.coproposers,
          style: textTheme.labelLarge?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 2),
        if (collaborators.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...collaborators.map((collaborator) {
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
            onTap: () => _addCollaborator(context),
            leading: VoicesAssets.icons.plus.buildIcon(size: 18),
            child: Text(context.l10n.add),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _addCollaborator(BuildContext context) async {
    final authorId = this.authorId;
    if (authorId == null) return;

    final result = await AddCollaboratorDialog.show(
      context,
      authorId: authorId,
      collaborators: CollaboratorsIds(collaborators: collaborators),
    );

    if (result != null && context.mounted) {
      collaborators = [...collaborators, result];
    }
  }

  void _removeCollaborator(CatalystId collaborator) {
    collaborators = [...collaborators]..remove(collaborator);
  }
}

class _CollaboratorsReadOnlyView extends StatelessWidget {
  final List<CatalystId> collaborators;

  const _CollaboratorsReadOnlyView(this.collaborators);

  @override
  Widget build(BuildContext context) {
    if (collaborators.isEmpty) {
      final colors = context.colors;
      final textTheme = context.textTheme;

      return Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.coproposersAndApplicants,
            style: textTheme.labelLarge?.copyWith(
              color: colors.textOnPrimaryLevel0,
            ),
          ),
          Text(
            context.l10n.proposalEditorNotAnswered,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textOnPrimaryLevel1,
            ),
          ),
        ],
      );
    }

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: collaborators.map(_CollaboratorReadItem.new).toList(),
    );
  }
}
