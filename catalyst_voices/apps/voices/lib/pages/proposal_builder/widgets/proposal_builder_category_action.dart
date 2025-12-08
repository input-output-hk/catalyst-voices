part of '../proposal_builder_segments.dart';

class _CategoryDetailsAction extends StatelessWidget {
  const _CategoryDetailsAction();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProposalBuilderBloc,
      ProposalBuilderState,
      CampaignCategoryDetailsViewModel?
    >(
      selector: (state) => state.category,
      builder: (context, category) {
        if (category == null) {
          return const Offstage();
        }
        return VoicesOutlinedButton(
          leading: VoicesAssets.icons.viewGrid.buildIcon(),
          child: Text(context.l10n.readCategoryBriefButtonLabel),
          onTap: () => unawaited(CategoryBriefDialog.show(context, category: category)),
        );
      },
    );
  }
}
