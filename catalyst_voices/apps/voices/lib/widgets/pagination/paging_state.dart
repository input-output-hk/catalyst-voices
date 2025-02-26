import 'dart:math';

import 'package:catalyst_voices/widgets/pagination/paging_status.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// A class that manages pagination state for a list of items.
///
/// [PagingState] handles all the logic related to pagination including:
/// * Current page tracking
/// * Loading states
/// * Error states
/// * Page boundaries calculations
/// * Item list management
///
/// Parameters:
/// * [currentPage]: The zero-based index of the current page
/// * [maxResults]: The total number of items available
/// * [itemsPerPage]: Number of items to display per page
/// * [itemList]: The current list of loaded items
/// * [error]: Any error that occurred during pagination
/// * [isLoading]: Whether the page is currently loading
///
/// Usage:
/// ```dart
/// final pagingState = PagingState<String>(
///   currentPage: 0,
///   maxResults: 100,
///   itemsPerPage: 20,
/// );
/// ```
class PagingState<ItemType> extends Equatable {
  final int currentPage;
  final int maxResults;
  final int itemsPerPage;
  final List<ItemType> itemList;
  final LocalizedException? error;
  final bool isLoading;

  const PagingState({
    required this.maxResults,
    required this.currentPage,
    required this.itemsPerPage,
    required this.itemList,
    this.error,
    this.isLoading = false,
  });

  int get currentFrom {
    return currentPage * itemsPerPage;
  }

  int get currentLastPage => (_itemCount / itemsPerPage).ceil() - 1;

  int get currentTo {
    if (itemList.isEmpty) {
      return 0;
    }
    return min(
      min(currentFrom + itemsPerPage - 1, itemList.length - 1),
      maxResults - 1,
    );
  }

  int get fromValue => currentFrom + 1;

  bool get isCompleted => _hasItems && !_isListingUnfinished;

  bool get isFirstPage => currentPage == 0;

  bool get isLastPage => currentTo >= maxResults - 1;

  @override
  List<Object?> get props => [
        currentPage,
        itemsPerPage,
        maxResults,
        itemList,
        error,
        isLoading,
        status,
      ];

  PagingStatus get status {
    if (itemList.isEmpty && !isLoading && error == null) {
      return PagingStatus.empty;
    } else if (isLoading) {
      return PagingStatus.loading;
    } else if (_isOngoing) {
      return PagingStatus.ongoing;
    } else if (isCompleted) {
      return PagingStatus.completed;
    } else if (_hasError) {
      return PagingStatus.error;
    }
    return PagingStatus.ongoing;
  }

  int get toValue => currentTo + 1;

  bool get _hasError => error != null;

  bool get _hasItems => itemList.isNotEmpty;

  bool get _isListingUnfinished => _hasItems && _itemCount < maxResults;

  bool get _isOngoing => _isListingUnfinished && !_hasError;

  int get _itemCount => itemList.length;

  PagingState<ItemType> copyWith({
    int? currentPage,
    int? currentLastPage,
    int? maxResults,
    int? itemsPerPage,
    List<ItemType>? itemList,
    Optional<LocalizedException>? error,
    bool isLoading = false,
  }) {
    return PagingState<ItemType>(
      currentPage: currentPage ?? this.currentPage,
      maxResults: maxResults ?? this.maxResults,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      itemList: itemList ?? this.itemList,
      error: error.dataOr(this.error),
      isLoading: isLoading,
    );
  }
}
