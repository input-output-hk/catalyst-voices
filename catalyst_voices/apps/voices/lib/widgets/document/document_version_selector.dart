import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    hide PopupMenuItem;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DocumentVersionSelector extends StatelessWidget {
  final List<DocumentVersion> versions;
  final ValueChanged<String>? onSelected;
  final bool showBorder;
  final bool readOnly;

  const DocumentVersionSelector({
    super.key,
    required this.versions,
    this.onSelected,
    this.showBorder = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final current = versions.singleWhereOrNull((element) => element.isCurrent);

    return Offstage(
      offstage: current == null,
      child: AbsorbPointer(
        absorbing: readOnly,
        child: VoicesOutlinedPopupMeuButton<String>(
          items: versions.map((e) => e.id).toList(),
          builder: (context, index) => _VersionOverview(data: versions[index]),
          onSelected: readOnly ? null : onSelected,
          showBorder: showBorder,
          leading: VoicesAssets.icons.documentText.buildIcon(),
          child: Text(context.l10n.nrOfIteration(current?.number ?? 0)),
        ),
      ),
    );
  }
}

class _VersionOverview extends StatelessWidget {
  final DocumentVersion data;

  const _VersionOverview({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Row(
      children: [
        Text(
          context.l10n.nrOfIteration(data.number),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const Spacer(),
        Offstage(
          offstage: !data.isLatest,
          child: Text(
            context.l10n.latestDocumentVersion,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: textTheme.labelLarge?.copyWith(
              color: colors.textOnPrimaryLevel1,
            ),
          ),
        ),
      ],
    );
  }
}
