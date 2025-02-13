import 'package:equatable/equatable.dart';

class PaginationPage<IdType> extends Equatable {
  final int pageKey;
  final int pageSize;
  final IdType? lastId;

  const PaginationPage({
    required this.pageKey,
    required this.pageSize,
    required this.lastId,
  });

  PaginationPage<IdType> copyWith({
    int? pageKey,
    int? pageSize,
    IdType? lastId,
  }) {
    return PaginationPage<IdType>(
      pageKey: pageKey ?? this.pageKey,
      pageSize: pageSize ?? this.pageSize,
      lastId: lastId ?? this.lastId,
    );
  }

  @override
  List<Object?> get props => [
        pageKey,
        pageSize,
        lastId,
      ];
}
