import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalHeader extends StatelessWidget {
  const ProposalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: colors.elevationsOnSurfaceNeutralLv0,
        border: Border(bottom: BorderSide(color: colors.outlineBorder)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          _ProposalMetadataSelector(),
          Spacer(flex: 5),
          _ProposalControlsSelector(),
          Spacer(),
        ],
      ),
    );
  }
}

class _ProposalControls extends StatelessWidget {
  final String? id;
  final DocumentVersions versions;
  final bool isFavorite;

  const _ProposalControls({
    required this.id,
    required this.versions,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DocumentVersionSelector(
          current: versions.current,
          versions: versions.all,
        ),
        ShareButton(onTap: () {}),
        FavoriteButton(
          isFavorite: isFavorite,
          onChanged: (value) {
            final id = this.id;
            if (id == null) {
              return;
            }

            final event = UpdateProposalFavoriteEvent(
              id: id,
              isFavorite: value,
            );

            context.read<ProposalBloc>().add(event);
          },
        ),
      ].separatedBy(const SizedBox(width: 8)).toList(),
    );
  }
}

class _ProposalControlsSelector extends StatelessWidget {
  const _ProposalControlsSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBloc, ProposalState, ProposalViewHeader>(
      selector: (state) => state.data.header,
      builder: (context, state) {
        return _ProposalControls(
          id: state.id,
          versions: state.versions,
          isFavorite: state.isFavourite,
        );
      },
    );
  }
}

class _ProposalMetadata extends StatelessWidget {
  final String title;
  final String author;
  final DateTime? createdAt;
  final int commentsCount;

  const _ProposalMetadata({
    required this.title,
    required this.author,
    required this.createdAt,
    required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    final titleTextStyle = (textTheme.titleMedium ?? const TextStyle())
        .copyWith(color: colors.textOnPrimaryLevel0);
    final subtitleTextStyle = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textOnPrimaryLevel1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleTextStyle,
        ),
        const SizedBox(height: 2),
        DefaultTextStyle(
          style: subtitleTextStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (author.isNotEmpty) Text(author),
              if (createdAt != null) TimestampText(createdAt!),
              Text(context.l10n.noOfComments(commentsCount)),
            ].separatedBy(const DotSeparator()).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProposalMetadataSelector extends StatelessWidget {
  const _ProposalMetadataSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBloc, ProposalState, ProposalViewHeader>(
      selector: (state) => state.data.header,
      builder: (context, state) {
        return _ProposalMetadata(
          title: state.title,
          author: state.authorDisplayName,
          createdAt: state.createdAt,
          commentsCount: state.commentsCount,
        );
      },
    );
  }
}
