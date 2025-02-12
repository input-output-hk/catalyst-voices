import 'package:catalyst_voices/widgets/pagination/paging_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

typedef PageRequestListener<PageKeyType, ItemType> = void Function(
  PageKeyType pageKey,
  int pageSize,
  ItemType? lastProposalId,
);

typedef PagingStateListener<ItemType> = void Function(
  PagingState<ItemType> status,
);

/// A controller that manages pagination state
/// and notifies listeners of changes.
///
/// The [PagingController] handles pagination logic including:
/// * Maintaining the current page number
/// * Managing a list of items
/// * Tracking loading and error states
/// * Notifying listeners when pages are requested or state changes
///
/// Example usage:
/// ```dart
/// final controller = PagingController(
///   initialPage: 1,
///   initialMaxResults: 100,
///   itemsPerPage: 20,
/// );
///
/// controller.addPageRequestListener((pageKey) {
///   // Load data for the requested page
/// });
/// ```
///
/// The controller requires:
/// * [initialPage]: The starting page number
/// * [initialMaxResults]: The total number of items available
/// * [itemsPerPage]: Number of items to load per page (defaults to 24)
///
/// Use [addPageRequestListener] to listen for page requests and
/// [addStatusListener] to monitor state changes.
class PagingController<ItemType> extends ValueNotifier<PagingState<ItemType>> {
  final int itemsPerPage;
  final int initialPage;
  final int initialMaxResults;

  PagingController({
    required this.initialPage,
    required this.initialMaxResults,
    this.itemsPerPage = 24,
  }) : super(
          PagingState(
            currentPage: initialPage,
            maxResults: initialMaxResults,
            itemsPerPage: itemsPerPage,
            isLoading: true,
          ),
        );

  ObserverList<PageRequestListener<int, ItemType>>? _pageRequestListeners =
      ObserverList<PageRequestListener<int, ItemType>>();

  ObserverList<PagingStateListener<ItemType>>? _statusListeners =
      ObserverList<PagingStateListener<ItemType>>();

  List<ItemType> get itemList => value.itemList;

  set itemList(List<ItemType> newItemList) {
    value = value.copyWith(itemList: newItemList);
  }

  LocalizedException? get error => value.error;

  set error(LocalizedException? newError) {
    value = value.copyWith(error: Optional(newError));
  }

  int get currentPage => value.currentPage;

  set currentPage(int newPage) {
    value = value.copyWith(currentPage: newPage);
  }

  int get maxResults => value.maxResults;

  set maxResults(int newMaxResults) {
    value = value.copyWith(maxResults: newMaxResults);
  }

  int get nextPageValue => currentPage + 1;

  @override
  set value(PagingState<ItemType> newValue) {
    if (value != newValue) {
      notifyStateListeners(newValue);
    }

    super.value = newValue;
  }

  void nextPage() {
    currentPage = nextPageValue;
  }

  void prevPage() {
    currentPage = currentPage - 1;
  }

  void appendPage(List<ItemType> newItems, int nextPage) {
    value = value.copyWith(
      currentPage: nextPage,
      itemList: newItems,
      error: null,
    );
  }

  void empty() {
    value = value.copyWith(
      itemList: [],
      isLoading: false,
      error: null,
    );
  }

  void addPageRequestListener(PageRequestListener<int, ItemType> listener) {
    _debugAssertNotDisposed();
    _pageRequestListeners?.add(listener);
  }

  void removePageRequestListener(PageRequestListener<int, ItemType> listener) {
    _debugAssertNotDisposed();
    _pageRequestListeners?.remove(listener);
  }

  void notifyPageRequestListeners(int pageKey) {
    _debugAssertNotDisposed();

    value = value.copyWith(isLoading: true);
    if (_pageRequestListeners?.isEmpty ?? true) {
      return;
    }

    final localListeners = List<PageRequestListener<int, ItemType>>.from(
      _pageRequestListeners ?? [],
    );
    final lastItem = itemList.isEmpty ? null : itemList.last;

    for (final listener in localListeners) {
      if (_pageRequestListeners!.contains(listener)) {
        listener(
          pageKey,
          value.itemsPerPage,
          lastItem,
        );
      }
    }
  }

  void addStatusListener(PagingStateListener<ItemType> listener) {
    _debugAssertNotDisposed();
    _statusListeners?.add(listener);
  }

  void removeStatusListener(PagingStateListener<ItemType> listener) {
    _debugAssertNotDisposed();
    _statusListeners?.remove(listener);
  }

  void notifyStateListeners(PagingState<ItemType> state) {
    _debugAssertNotDisposed();
    if (_statusListeners?.isEmpty ?? true) {
      return;
    }

    final localListeners =
        List<PagingStateListener<ItemType>>.from(_statusListeners!);
    for (final listener in localListeners) {
      if (_statusListeners!.contains(listener)) {
        listener(state);
      }
    }
  }

  bool _debugAssertNotDisposed() {
    assert(
      () {
        if (_pageRequestListeners == null || _statusListeners == null) {
          throw Exception(
            'A PagingController was used after being disposed.\nOnce you have '
            'called dispose() on a PagingController, it can no longer be '
            'used.\nIf you’re using a Future, it probably completed after '
            'the disposal of the owning widget.\nMake sure dispose() has not '
            'been called yet before using the PagingController.',
          );
        }
        return true;
      }(),
      'A PagingController was used after being disposed.',
    );
    return true;
  }

  @override
  void dispose() {
    _pageRequestListeners = null;
    _statusListeners = null;
    super.dispose();
  }
}
