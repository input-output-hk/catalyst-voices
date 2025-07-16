part of '../proposals_page.dart';

class _ProposalsContent extends StatelessWidget {
  final TabController tabController;
  final PagingController<ProposalBrief> pagingController;

  const _ProposalsContent({
    required this.tabController,
    required this.pagingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            runSpacing: 10,
            children: [
              ProposalsTabs(controller: tabController),
              const ProposalsControls(),
            ],
          ),
        ),
        const ProposalsTabsDivider(),
        const SizedBox(height: 16),
        const ProposalsSubHeader(),
        const SizedBox(height: 16),
        ProposalsPagination(controller: pagingController),
      ],
    );
  }
}
