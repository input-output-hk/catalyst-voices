import 'dart:convert';

import 'package:flutter/services.dart';

// TODO(damian-molinski): This class should be removed once Repository does not
// build document's base on it.
class VoicesDocumentsTemplates {
  VoicesDocumentsTemplates._();

  static final Future<Map<String, dynamic>> proposalF14Schema = _getJsonAsset(
    'assets/document_templates/proposal/F14-Generic/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json',
  );
  static final Future<Map<String, dynamic>> proposalF14Document = _getJsonAsset(
    'assets/document_templates/proposal/F14-Generic/example.proposal.json',
  );

  static Future<Map<String, dynamic>> _getJsonAsset(String name) async {
    final encodedData = await rootBundle.loadString(
      'packages/catalyst_voices_assets/$name',
    );
    final decodedData = json.decode(encodedData) as Map<String, dynamic>;

    return decodedData;
  }
}
