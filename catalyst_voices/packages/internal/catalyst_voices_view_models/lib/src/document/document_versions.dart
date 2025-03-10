import 'package:equatable/equatable.dart';

final class DocumentVersions extends Equatable {
  final String? current;
  final List<String> all;

  const DocumentVersions({
    this.current,
    this.all = const [],
  });

  @override
  List<Object?> get props => [current, all];
}
