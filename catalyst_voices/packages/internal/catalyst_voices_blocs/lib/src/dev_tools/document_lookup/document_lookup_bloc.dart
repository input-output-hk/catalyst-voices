import 'dart:convert';

import 'package:catalyst_voices_blocs/src/dev_tools/document_lookup/document_lookup.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Allows lookup of documents by their ref.
final class DocumentLookupBloc extends Bloc<DocumentLookupEvent, DocumentLookupState> {
  final DocumentsService _documentsService;
  final DocumentMapper _documentMapper;

  DocumentLookupBloc(
    this._documentsService,
    this._documentMapper,
  ) : super(const DocumentLookupState()) {
    on<LookupRefDocumentsEvent>(_handleDocumentLookup);
  }

  Future<void> _handleDocumentLookup(
    LookupRefDocumentsEvent event,
    Emitter<DocumentLookupState> emit,
  ) async {
    emit(const DocumentLookupState());

    final documents = await _documentsService.lookup(event.ref);
    final tilesData = documents.map(_mapDocumentDataToTileData).toList();

    if (!emit.isDone) {
      emit(DocumentLookupState(documents: tilesData));
    }
  }

  DocumentLookupTileData _mapDocumentDataToTileData(DocumentData data) {
    const encoder = JsonEncoder.withIndent('  ');

    final metadata = encoder.convert(_documentMapper.metadataToMap(data.metadata));
    final content = encoder.convert(data.content.data);

    return DocumentLookupTileData(
      ref: data.id,
      metadata: metadata,
      content: content,
    );
  }
}
