import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Represents the immutable, raw binary evidence of a signed document (e.g., the COSE object).
///
/// Value is usually obtained from the [SignedDocument] or remote source.
extension type const DocumentArtifact(Uint8List value) {}
