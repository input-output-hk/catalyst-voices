import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';

/// v0.0.1 -> v0.0.4 spec: https://github.com/input-output-hk/catalyst-libs/pull/341/files#diff-2827956d681587dfd09dc733aca731165ff44812f8322792bf6c4a61cf2d3b85
final class SignedDocumentTestData {
  /// A hex encoded cbor of proposal document created with v0.0.1 spec.
  static final Future<Uint8List> signedDocumentV0_0_1Bytes = _getBytesFromHexFile(
    'test/fixture/signed_document/signed_document_v0_0_1.hex',
  );

  /// A hex encoded cbor of proposal document created with v0.0.4 spec.
  static final Future<Uint8List> signedDocumentV0_0_4Bytes = _getBytesFromHexFile(
    'test/fixture/signed_document/signed_document_v0_0_4.hex',
  );

  /// A json file with exported proposal with v0.0.1 spec.
  static final Future<Uint8List> exportedProposalV0_0_1Bytes = _getBytesFromJsonFile(
    'test/fixture/signed_document/exported_proposal_v0_0_1.json',
  );

  /// A json file with exported proposal with v0.0.4 spec.
  static final Future<Uint8List> exportedProposalV0_0_4Bytes = _getBytesFromJsonFile(
    'test/fixture/signed_document/exported_proposal_v0_0_4.json',
  );

  static Future<Uint8List> _getBytesFromHexFile(String path) async {
    final file = File(path);
    final data = await file.readAsString();
    return Uint8List.fromList(hex.decode(data.trim()));
  }

  static Future<Uint8List> _getBytesFromJsonFile(String path) async {
    final file = File(path);
    final data = await file.readAsString();
    return Uint8List.fromList(utf8.encode(data.trim()));
  }
}
