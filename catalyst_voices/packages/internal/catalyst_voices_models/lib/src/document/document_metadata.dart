import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract base class DocumentMetadata extends Equatable {
  final String id;
  final String version;

  const DocumentMetadata({
    required this.id,
    required this.version,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        version,
      ];
}
