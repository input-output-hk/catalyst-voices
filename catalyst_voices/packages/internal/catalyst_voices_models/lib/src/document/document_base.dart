import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract base class DocumentBase extends Equatable {
  /// Unique identifier of document. Uuid-v7
  final String id;

  /// Documents are immutable so [id] does not change but we can have
  /// different versions of same document.
  final String version;

  const DocumentBase({
    required this.id,
    required this.version,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [id, version];
}
