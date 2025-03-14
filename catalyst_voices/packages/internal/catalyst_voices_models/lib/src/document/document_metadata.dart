import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract base class DocumentMetadata extends Equatable {
  final DocumentRef selfRef;
  final SignedDocumentRef? categoryId;

  DocumentMetadata({
    required this.selfRef,
    this.categoryId,
  }) : assert(selfRef.isExact, 'SelfRef have to be exact!');

  @override
  @mustCallSuper
  List<Object?> get props => [
        selfRef,
        categoryId,
      ];
}
