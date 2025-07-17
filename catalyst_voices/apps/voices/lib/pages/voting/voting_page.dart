import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/layouts/header_and_content_layout.dart';
import 'package:catalyst_voices/widgets/pagination/paging_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'widgets/voting_content.dart';
part 'widgets/voting_header.dart';

class VotingPage extends StatefulWidget {
  final SignedDocumentRef? categoryId;
  final ProposalsFilterType? type;

  const VotingPage({
    super.key,
    this.categoryId,
    this.type,
  });

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PagingController<ProposalBrief> _pagingController;

  @override
  Widget build(BuildContext context) {
    return const HeaderAndContentLayout(
      header: _VotingHeader(),
      content: _VotingContent(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final proposalsFilterType = _determineFilterType();

    _tabController = TabController(
      initialIndex: proposalsFilterType.index,
      length: ProposalsFilterType.values.length,
      vsync: this,
    );

    _pagingController = PagingController(
      initialPage: 0,
      initialMaxResults: 0,
    );

    // TODO(dt-iohk): handle cubit initialisation when VotingCubit is there.
    // context.read<ProposalsCubit>().init(
    //       onlyMyProposals: widget.type?.isMy ?? false,
    //       category: widget.categoryId,
    //       type: proposalsFilterType,
    //       order: const Alphabetical(),
    //     );

    _pagingController
      ..addPageRequestListener(_handleProposalsPageRequest)
      ..notifyPageRequestListeners(0);
  }

  ProposalsFilterType _determineFilterType() {
    final isProposerUnlock = context.read<SessionCubit>().state.isProposerUnlock;
    final requestedType = widget.type;

    if (!isProposerUnlock && (requestedType?.isMy ?? false)) {
      _updateRoute(filterType: ProposalsFilterType.total);
    }

    return requestedType ?? ProposalsFilterType.total;
  }

  Future<void> _handleProposalsPageRequest(
    int pageKey,
    int pageSize,
    ProposalBrief? lastProposalId,
  ) async {
    // TODO(dt-iohk): handle cubit callback when VotingCubit is there
    // final request = PageRequest(page: pageKey, size: pageSize);
    // await context.read<ProposalsCubit>().getProposals(request);
  }

  void _updateRoute({
    Optional<String>? categoryId,
    ProposalsFilterType? filterType,
  }) {
    Router.neglect(context, () {
      final effectiveCategoryId = categoryId.dataOr(widget.categoryId?.id);
      final effectiveType = filterType?.name ?? widget.type?.name;

      VotingRoute(
        categoryId: effectiveCategoryId,
        type: effectiveType,
      ).replace(context);
    });
  }
}
