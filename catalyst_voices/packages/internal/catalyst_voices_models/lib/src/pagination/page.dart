import 'package:equatable/equatable.dart';

/// Simple pagination page representation.
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

  const Page.empty({
    int page = 0,
    int maxPerPage = 0,
    int total = 0,
  }) : this(
         page: page,
         maxPerPage: maxPerPage,
         total: total,
         items: const [],
       );

  @override
  List<Object?> get props => [
    page,
    maxPerPage,
    total,
    items,
  ];

  Future<Page<T>> asyncMap<T>(Future<T> Function(E e) mapper) async {
    return Page<T>(
      page: page,
      maxPerPage: maxPerPage,
      total: total,
      items: await items.map(mapper).wait,
    );
  }

  Page<E> copyWith({
    int? total,
    List<E>? items,
  }) {
    return Page<E>(
      page: page,
      maxPerPage: maxPerPage,
      total: total ?? this.total,
      items: items ?? this.items,
    );
  }

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
