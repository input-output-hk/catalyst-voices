import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart';

/// Commonly used pattern for representing uuid as ver.
///
/// See [UuidHiLo].
mixin VerHiLoTableMixin on Table {
  Int64Column get verHi => int64()();

  Int64Column get verLo => int64()();
}
