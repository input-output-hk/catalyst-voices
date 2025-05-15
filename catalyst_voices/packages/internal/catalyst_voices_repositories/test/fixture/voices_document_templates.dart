import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

class VoicesDocumentsTemplates {
  static final Future<Map<String, dynamic>> proposalF14Schema =
      _getJsonAssetFromDocs(
    '/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json',
  );

  static final Future<Map<String, dynamic>> proposalF14Document =
      _getJsonAssetFromDocs(
    '/src/architecture/08_concepts/document_templates/proposal/F14-Generic/example.proposal.json',
  );

  static final Future<Map<String, dynamic>> commentF14Schema =
      _getJsonAssetFromDocs(
    '/src/architecture/08_concepts/document_templates/F14-Comments/0b8424d4-ebfd-46e3-9577-1775a69d290c.schema.json',
  );

  VoicesDocumentsTemplates._();

  /// Starting from current dir go upwards until current dir will contain
  /// `/docs` folder and return the `/docs` [Directory].
  static Future<Directory> _getDocsRoot() async {
    var dir = Directory.current;

    while (true) {
      final list = dir.listSync();
      final docs = list.firstWhereOrNull((e) => e.path.endsWith('/docs'));
      if (docs != null) {
        return Directory(docs.path);
      } else {
        final parentDir = dir.parent;
        if (dir.path == parentDir.path) {
          throw StateError(
            'Cannot find /docs directory in the repo. '
            'Started lookup from ${Directory.current.path}.',
          );
        } else {
          dir = dir.parent;
        }
      }
    }
  }

  static Future<Map<String, dynamic>> _getJsonAssetFromDocs(String name) async {
    final docsRoot = await _getDocsRoot();
    final encodedData = await File(docsRoot.path + name).readAsString();
    final decodedData = json.decode(encodedData) as Map<String, dynamic>;
    return decodedData;
  }
}
