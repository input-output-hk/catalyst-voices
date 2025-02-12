import 'package:catalyst_voices_models/catalyst_voices_models.dart';

class ProposalPaginationRequest extends PaginationPage<String?> {
  final String? categoryId;
  final String? searchValue;
  final ProposalPublish? stage;
  final bool getFavorites;

  const ProposalPaginationRequest({
    required super.pageKey,
    required super.pageSize,
    required super.lastId,
    this.categoryId,
    this.searchValue,
    this.stage,
    this.getFavorites = false,
  });

  @override
  ProposalPaginationRequest copyWith({
    String? categoryId,
    String? searchValue,
    ProposalPublish? stage,
    int? pageKey,
    int? pageSize,
    String? lastId,
    bool? getFavorites,
  }) {
    return ProposalPaginationRequest(
      categoryId: categoryId ?? this.categoryId,
      searchValue: searchValue ?? this.searchValue,
      stage: stage ?? this.stage,
      pageKey: pageKey ?? this.pageKey,
      pageSize: pageSize ?? this.pageSize,
      lastId: lastId ?? this.lastId,
      getFavorites: getFavorites ?? this.getFavorites,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        searchValue,
        stage,
        getFavorites,
        ...super.props,
      ];
}
