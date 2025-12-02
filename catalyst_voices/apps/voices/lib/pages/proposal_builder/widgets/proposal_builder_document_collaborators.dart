part of '../proposal_builder_segments.dart';

typedef CollaboratorsData = ({CatalystId? authorId, List<CatalystId> collaborators});

class __CollaboratorsDetails extends StatelessWidget {
  final DocumentProperty property;
  final CollaboratorsData data;
  final int maxCollaborators;

  const __CollaboratorsDetails({
    required this.data,
    required this.property,
    required this.maxCollaborators,
  });

  @override
  Widget build(BuildContext context) {
    final tileController = DocumentBuilderSectionTileControllerScope.of(context);
    final tileData = tileController.getData<DocumentBuilderSectionTileData>(property.nodeId);
    final isEditMode = tileData?.isEditMode ?? false;

    return isEditMode
        ? _CollaboratorsEditView(
            data: data,
            property: property,
            maxCollaborators: maxCollaborators,
          )
        : _CollaboratorsReadOnlyView(data.collaborators);
  }
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
          Expanded(
            child: Row(
              children: [
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
  final DocumentProperty property;
  final int maxCollaborators;

  const _CollaboratorsDetails({
    required this.property,
    required this.maxCollaborators,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, CollaboratorsData>(
      selector: (state) => (
        authorId: state.metadata.authorId,
        collaborators: state.metadata.collaborators,
      ),
      builder: (_, data) => __CollaboratorsDetails(
        property: property,
        data: data,
        maxCollaborators: maxCollaborators,
      ),
    );
  }

  static DocumentNodeId getDataNodeId(DocumentNodeId tileNodeId) => tileNodeId.child('data');
}

class _CollaboratorsEditView extends StatefulWidget {
  final DocumentProperty property;
  final CollaboratorsData data;
  final int maxCollaborators;

  const _CollaboratorsEditView({
    required this.data,
    required this.property,
    required this.maxCollaborators,
  });

  @override
  State<_CollaboratorsEditView> createState() => _CollaboratorsEditViewState();
}

class _CollaboratorsEditViewState extends State<_CollaboratorsEditView> {
  late DocumentBuilderSectionTileController _tileController;

  bool get _canAddMore => _collaborators.length < widget.maxCollaborators;

  List<CatalystId> get _collaborators =>
      _tileController.getData<List<CatalystId>>(_dataNodeId) ?? [];

  set _collaborators(List<CatalystId> value) => _tileController.setData(_dataNodeId, value);

  DocumentNodeId get _dataNodeId => _CollaboratorsDetails.getDataNodeId(_tileNodeId);

  bool get _hasEditingData => _tileController.getData<List<CatalystId>>(_dataNodeId) != null;

  DocumentNodeId get _tileNodeId => widget.property.nodeId;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.collaboratorsSectionDescription(widget.maxCollaborators),
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
        if (_collaborators.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._collaborators.map((collaborator) {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tileController = DocumentBuilderSectionTileControllerScope.of(context);
    if (!_hasEditingData) {
      _collaborators = widget.data.collaborators;
    }
  }

  @override
  void didUpdateWidget(covariant _CollaboratorsEditView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.collaborators != widget.data.collaborators) {
      _collaborators = List.of(widget.data.collaborators);
    }
  }

  Future<void> _addCollaborator() async {
    final authorId = widget.data.authorId;
    if (authorId == null) return;

    final result = await AddCollaboratorDialog.show(
      context,
      authorId: authorId,
      collaborators: CollaboratorsIds(collaborators: _collaborators),
    );

    if (result != null && mounted) {
      setState(() => _collaborators = [..._collaborators, result]);
    }
  }

  void _removeCollaborator(CatalystId collaborator) {
    setState(() => _collaborators = [..._collaborators]..remove(collaborator));
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

extension on CatalystId {
  String getDisplayName(BuildContext context) {
    final username = this.username;

    if (username == null || username.isEmpty) {
      return context.l10n.anonymousUsername;
    }

    return username;
  }
}
