import 'package:catalyst_voices_blocs/src/dev_tools/document_data_preview/document_data_preview.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class DocumentDataPreviewBloc
    extends Bloc<DocumentDataPreviewEvent, DocumentDataPreviewState> {
  final DocumentsService _documentsService;

  DocumentDataPreviewBloc(
    this._documentsService,
  ) : super(const DocumentDataPreviewState());
}
