import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DocumentsDataListView extends StatelessWidget {
  const DocumentsDataListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentLookupBloc, DocumentLookupState, List<DocumentLookupTileData>>(
      selector: (state) => state.documents ?? const [],
      builder: (context, state) {
        return _DocumentsDataListView(documents: state);
      },
    );
  }
}

class _DocumentDataTile extends StatelessWidget {
  final DocumentLookupTileData document;

  const _DocumentDataTile({
    required super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(
        side: BorderSide(),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTileNameText('Metadata'),
            SelectableText(document.metadata),
            const SizedBox(height: 12),
            const _SectionTileNameText('Content'),
            SelectableText(document.content),
          ],
        ),
      ),
    );
  }
}

class _DocumentsDataListView extends StatelessWidget {
  final List<DocumentLookupTileData> documents;

  const _DocumentsDataListView({
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];

        return _DocumentDataTile(
          key: ValueKey('Document[${document.ref}]Tile'),
          document: document,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}

class _SectionTileNameText extends StatelessWidget {
  final String data;

  const _SectionTileNameText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
