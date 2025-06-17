import 'package:catalyst_voices_blocs/src/dev_tools/document_lookup/document_lookup.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class DocumentLookupBloc extends Bloc<DocumentLookupEvent, DocumentLookupState> {
  final DocumentsService _documentsService;

  DocumentLookupBloc(
    this._documentsService,
  ) : super(const DocumentLookupState()) {
    on<LookupRefDocumentsEvent>(_handleDocumentLookup);
  }

  Future<void> _handleDocumentLookup(
    LookupRefDocumentsEvent event,
    Emitter<DocumentLookupState> emit,
  ) async {
    //
  }
}
