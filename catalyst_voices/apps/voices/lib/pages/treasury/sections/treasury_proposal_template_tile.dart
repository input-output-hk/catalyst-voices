import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TreasuryProposalTemplateTile extends StatelessWidget {
  final TreasurySection data;

  const TreasuryProposalTemplateTile(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SectionBaseTile(
      id: data.id,
      child: WorkspaceTextTileContainer(
        name: data.resolveTitle(context),
        headerActions: [
          VoicesTextButton(
            onTap: data.isEditable ? () {} : null,
            child: Text(context.l10n.stepEdit),
          ),
        ],
        content: data.resolveDesc(context) ?? data.resolveTitle(context),
      ),
    );
  }
}
