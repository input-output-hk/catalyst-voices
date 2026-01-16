import 'dart:typed_data';

import 'package:catalyst_voices_models/src/document/data/document_content_type.dart';
import 'package:catalyst_voices_models/src/signed_document/signed_document_payload.dart';
import 'package:catalyst_voices_models/src/signed_document/signed_document_raw_payload.dart';

/// The direct binary representation of [SignedDocumentPayload].
///
/// This type can be directly translated to the model class
/// via [SignedDocumentPayload.fromBytes] if the [DocumentContentType] is known.
///
/// It differs from [SignedDocumentRawPayload] since that type might be compressed
/// and further transformed thus making the conversion back to [SignedDocumentPayload]
/// impossible without reversing the compression and other transformations.
extension type const SignedDocumentPayloadBytes(Uint8List bytes) {}
