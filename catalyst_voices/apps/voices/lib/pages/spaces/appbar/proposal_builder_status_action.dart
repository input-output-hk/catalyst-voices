import 'dart:async';

import 'package:catalyst_voices/pages/proposal_builder/dialog/publish_proposal_iteration_dialog.dart';
import 'package:catalyst_voices/pages/proposal_builder/dialog/submit_proposal_for_review_dialog.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalBuilderStatusAction extends StatelessWidget {
  const ProposalBuilderStatusAction({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      offset: const Offset(0, 48),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: 420),
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          for (final item in _MenuItemEnum.values)
            PopupMenuItem(
              value: item.index,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _MenuItem(item: item),
            ),
        ].separatedBy(const PopupMenuDivider(height: 0)).toList();
      },
      onSelected: (value) {
        final item = _MenuItemEnum.values[value];
        _onSelected(context, item);
      },
    );
  }

  void _onSelected(BuildContext context, _MenuItemEnum item) {
    switch (item) {
      case _MenuItemEnum.back:
        const WorkspaceRoute().go(context);
      case _MenuItemEnum.publish:
        context.read<ProposalBuilderBloc>().add(const PublishProposalEvent());

        // TODO(dtscalac): fill in with correct data
        unawaited(
          PublishProposalIterationDialog.show(
            context: context,
            proposalTitle:
                'Could have a different title, but has the same Proposal '
                'IDand a longer title to make it.',
            currentVersion: null,
            nextVersion: '1',
          ),
        );
      case _MenuItemEnum.submit:
        context.read<ProposalBuilderBloc>().add(const SubmitProposalEvent());

        // TODO(dtscalac): fill in with correct data
        unawaited(
          SubmitProposalForReviewDialog.show(
            context: context,
            proposalTitle:
                'Could have a different title, but has the same Proposal '
                'IDand a longer title to make it.',
            currentVersion: '3',
            nextVersion: '4',
          ),
        );
      case _MenuItemEnum.share:
        context.read<ProposalBuilderBloc>().add(const ShareProposalEvent());
      case _MenuItemEnum.export:
        context.read<ProposalBuilderBloc>().add(const ExportProposalEvent());
    }
  }
}

class _MenuItem extends StatelessWidget {
  final _MenuItemEnum item;

  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final description = item.description(context);
    return ListTile(
      title: Text(
        item.title(context),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: description == null
          ? null
          : Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colors.textOnPrimaryLevel1,
                  ),
            ),
      leading: item.icon.buildIcon(),
      mouseCursor: SystemMouseCursors.click,
    );
  }
}

enum _MenuItemEnum {
  back,
  publish,
  submit,
  share,
  export;

  SvgGenImage get icon {
    switch (this) {
      case _MenuItemEnum.back:
        return VoicesAssets.icons.logout;
      case _MenuItemEnum.publish:
        return VoicesAssets.icons.chatAlt2;
      case _MenuItemEnum.submit:
        return VoicesAssets.icons.badgeCheck;
      case _MenuItemEnum.share:
        return VoicesAssets.icons.upload;
      case _MenuItemEnum.export:
        return VoicesAssets.icons.folderOpen;
    }
  }

  String? description(BuildContext context) {
    return switch (this) {
      _MenuItemEnum.publish =>
        context.l10n.proposalEditorStatusDropdownPublishDescription,
      _MenuItemEnum.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitDescription,
      _MenuItemEnum.back || _MenuItemEnum.share || _MenuItemEnum.export => null,
    };
  }

  String title(BuildContext context) {
    return switch (this) {
      _MenuItemEnum.back => context.l10n.proposalEditorStatusDropdownBackTitle,
      _MenuItemEnum.publish =>
        context.l10n.proposalEditorStatusDropdownPublishTitle,
      _MenuItemEnum.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitTitle,
      _MenuItemEnum.share =>
        context.l10n.proposalEditorStatusDropdownShareTitle,
      _MenuItemEnum.export =>
        context.l10n.proposalEditorStatusDropdownExportTitle
    };
  }
}
