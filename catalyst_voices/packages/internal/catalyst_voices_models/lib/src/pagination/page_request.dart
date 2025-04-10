import 'package:equatable/equatable.dart';

final class PageRequest extends Equatable {
  final int page;
  final int size;

  const PageRequest({
    required this.page,
    required this.size,
  });

  @override
  List<Object?> get props => [
        page,
        size,
      ];
}
