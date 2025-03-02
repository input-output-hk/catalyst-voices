import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract base class DocumentMetadata extends Equatable {
  final DocumentRef selfRef;

  DocumentMetadata({
    required this.selfRef,
  }) : assert(selfRef.isExact, 'SelfRef have to be exact!');

  @override
  @mustCallSuper
  List<Object?> get props => [
        selfRef,
      ];
}
