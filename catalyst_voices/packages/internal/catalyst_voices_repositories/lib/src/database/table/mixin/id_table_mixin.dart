import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart';

/// Commonly used pattern for representing uuid as id.
///
/// See [UuidHiLo].
mixin IdHiLoTableMixin on Table {
  Int64Column get idHi => int64()();

  Int64Column get idLo => int64()();
}
