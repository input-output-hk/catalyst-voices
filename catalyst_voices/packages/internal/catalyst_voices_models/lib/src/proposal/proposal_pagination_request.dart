import 'package:catalyst_voices_models/catalyst_voices_models.dart';

class ProposalPaginationRequest extends PaginationPage<String?> {
  final SignedDocumentRef? categoryId;
  final String? searchValue;
  final ProposalPublish? stage;
  final bool usersProposals;
  final bool usersFavorite;

  const ProposalPaginationRequest({
    required super.pageKey,
    required super.pageSize,
    required super.lastId,
    this.categoryId,
    this.searchValue,
    this.stage,
    this.usersProposals = false,
    this.usersFavorite = false,
  });

  @override
  List<Object?> get props => [
        categoryId,
        searchValue,
        stage,
        usersProposals,
        usersFavorite,
        ...super.props,
      ];

  @override
  ProposalPaginationRequest copyWith({
    SignedDocumentRef? categoryId,
    String? searchValue,
    ProposalPublish? stage,
    int? pageKey,
    int? pageSize,
    String? lastId,
    bool? getFavorites,
    bool? usersProposals,
    bool? usersFavorite,
  }) {
    return ProposalPaginationRequest(
      categoryId: categoryId ?? this.categoryId,
      searchValue: searchValue ?? this.searchValue,
      stage: stage ?? this.stage,
      pageKey: pageKey ?? this.pageKey,
      pageSize: pageSize ?? this.pageSize,
      lastId: lastId ?? this.lastId,
      usersProposals: usersProposals ?? this.usersProposals,
      usersFavorite: usersFavorite ?? this.usersFavorite,
    );
  }
}
