import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class DocumentIndex extends Equatable {
  final List<DocumentIndexDoc> docs;
  final DocumentIndexPage page;

  const DocumentIndex({
    required this.docs,
    required this.page,
  });

  @override
  List<Object?> get props => [docs, page];
}

final class DocumentIndexDoc extends Equatable {
  final String id;
  final List<DocumentIndexDocVersion> ver;

  const DocumentIndexDoc({
    required this.id,
    required this.ver,
  });

  @override
  List<Object?> get props => [id, ver];

  Iterable<SignedDocumentRef> refs({
    Set<DocumentBaseType> exclude = const {},
  }) {
    return ver
        .map((ver) {
          return [
            if (ver.type.baseTypes.none((value) => exclude.contains(value)))
              SignedDocumentRef(id: id, ver: ver.ver),
            if (ver.ref case final value?) value,
            if (ver.reply case final value?) value,
            if (ver.template case final value? when !exclude.contains(DocumentBaseType.template))
              value,
            if (ver.brand case final value? when !exclude.contains(DocumentBaseType.brand)) value,
            if (ver.campaign case final value? when !exclude.contains(DocumentBaseType.campaign))
              value,
            if (ver.category case final value? when !exclude.contains(DocumentBaseType.category))
              value,
            ...?ver.parameters,
          ];
        })
        .expand((element) => element);
  }
}

final class DocumentIndexDocVersion extends Equatable {
  final String ver;
  final DocumentType type;
  final SignedDocumentRef? ref;
  final SignedDocumentRef? reply;
  final List<SignedDocumentRef>? parameters;
  final SignedDocumentRef? template;
  final SignedDocumentRef? brand;
  final SignedDocumentRef? campaign;
  final SignedDocumentRef? category;

  const DocumentIndexDocVersion({
    required this.ver,
    required this.type,
    this.ref,
    this.reply,
    this.parameters,
    this.template,
    this.brand,
    this.campaign,
    this.category,
  });

  @override
  List<Object?> get props => [
    ver,
    type,
    ref,
    reply,
    parameters,
    template,
    brand,
    campaign,
    category,
  ];
}

final class DocumentIndexPage extends Equatable {
  final int page;
  final int limit;
  final int remaining;

  const DocumentIndexPage({
    required this.page,
    required this.limit,
    required this.remaining,
  });

  @override
  List<Object?> get props => [page, limit, remaining];
}
