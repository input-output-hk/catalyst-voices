import 'package:equatable/equatable.dart';

base class Page<E> extends Equatable {
  final int page;
  final int maxPerPage;
  final int total;
  final List<E> items;

  const Page({
    required this.page,
    required this.maxPerPage,
    required this.total,
    required this.items,
  });

  const Page.empty()
      : this(
          page: 0,
          maxPerPage: 0,
          total: 0,
          items: const [],
        );

  @override
  List<Object?> get props => [
        page,
        maxPerPage,
        total,
        items,
      ];

  Page<T> copyWithItems<T>(List<T> items) {
    return Page<T>(
      page: page,
      maxPerPage: maxPerPage,
      total: total,
      items: items,
    );
  }

  Page<T> map<T>(T Function(E e) mapper) {
    return Page<T>(
      page: page,
      maxPerPage: maxPerPage,
      total: total,
      items: items.map(mapper).toList(),
    );
  }
}
