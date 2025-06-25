import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

/// Extension on [ProposalsFilterType] to provide utility methods:
///
/// - [noOf]: Returns the number of proposals for the given filter type.
/// - [tabKey]: Returns the key for the given filter type.
extension ProposalsFilterTypeExt on ProposalsFilterType {
  String noOf(
    BuildContext context, {
    required int count,
  }) {
    return switch (this) {
      ProposalsFilterType.total => context.l10n.noOfAll(count),
      ProposalsFilterType.drafts => context.l10n.noOfDraft(count),
      ProposalsFilterType.finals => context.l10n.noOfFinal(count),
      ProposalsFilterType.favorites => context.l10n.noOfFavorites(count),
      ProposalsFilterType.my => context.l10n.noOfMyProposals(count),
    };
  }

  Key tabKey() {
    return switch (this) {
      ProposalsFilterType.total => const Key('AllProposalsTab'),
      ProposalsFilterType.drafts => const Key('DraftProposalsTab'),
      ProposalsFilterType.finals => const Key('FinalProposalsTab'),
      ProposalsFilterType.favorites => const Key('FavoriteProposalsTab'),
      ProposalsFilterType.my => const Key('MyProposalsTab'),
    };
  }
}
