import 'dart:math';

import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GirdPaginationPageContainer extends StatefulWidget {
  final int currentPage;
  final List<ProposalViewModel> items;
  final int maxResults;
  final int resultsPerPage;
  final ValueChanged<int> onNextPage;

  const GirdPaginationPageContainer({
    super.key,
    required this.currentPage,
    required this.items,
    required this.maxResults,
    this.resultsPerPage = 24,
    required this.onNextPage,
  });

  @override
  State<GirdPaginationPageContainer> createState() =>
      _GirdPaginationPageContainerState();
}

class _GirdPaginationPageContainerState
    extends State<GirdPaginationPageContainer> {
  late int _currentPage;
  late int _from;
  late int _to;

  int get _lastPage => (widget.items.length / widget.resultsPerPage).ceil() - 1;
  int get _fromNumber => _from + 1;
  int get _toNumber => _to + 1;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
    _from = _setFrom();
    _to = _setTo();
  }

  @override
  void didUpdateWidget(GirdPaginationPageContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // New items are added to the list and we need to show the new page of items
    if (widget.items.length > oldWidget.items.length &&
        _currentPage == _lastPage) {
      _currentPage = widget.currentPage;
      _nextPage();
      _from = _setFrom();
      _to = _setTo();
    }

    if (widget.items.length < oldWidget.items.length) {
      _currentPage = widget.currentPage;
      _currentPage = _lastPage;
      _from = _setFrom();
      _to = _setTo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = _from; i <= _to; i++)
              ProposalCard(
                key: UniqueKey(),
                proposal: widget.items[i],
                showStatus: false,
                showLastUpdate: false,
                showComments: false,
                showSegments: false,
                isFavorite: widget.items[i].isFavorite,
                onFavoriteChanged: (isFavorite) async {
                  await context.read<ProposalsCubit>().onChangeFavoriteProposal(
                        widget.items[i].id,
                        isFavorite: isFavorite,
                      );
                },
              ),
          ],
        ),
        Row(
          children: [
            Text(
              '$_fromNumber-$_toNumber of ${widget.maxResults} proposals',
            ),
            VoicesIconButton(
              onTap: _currentPage > 0 ? _prevPage : null,
              child: VoicesAssets.icons.chevronLeft.buildIcon(),
            ),
            VoicesIconButton(
              onTap: (_currentPage == _lastPage &&
                      widget.items.length >= widget.maxResults)
                  ? null
                  : _onNextPageTap,
              child: VoicesAssets.icons.chevronRight.buildIcon(),
            ),
          ],
        ),
      ],
    );
  }

  int _setFrom() {
    return _currentPage * widget.resultsPerPage;
  }

  int _setTo() {
    if (widget.items.length > widget.maxResults) {
      return widget.maxResults - 1;
    }
    final to =
        _currentPage * widget.resultsPerPage + (widget.resultsPerPage - 1);
    return min(widget.items.length - 1, to);
  }

  void _prevPage() {
    setState(() {
      _currentPage -= 1;
      _from = _setFrom();
      _to = _setTo();
    });
  }

  void _nextPage() {
    setState(() {
      _currentPage += 1;
      _from = _setFrom();
      _to = _setTo();
    });
  }

  void _onNextPageTap() {
    if (_currentPage < _lastPage && _to < (widget.items.length - 1)) {
      _nextPage();
    } else {
      widget.onNextPage(_currentPage + 1);
    }
    return;
  }
}
