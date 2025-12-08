import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart';

mixin AccountTableMixin on Table {
  /// Full [CatalystId] uri.
  TextColumn get accountId => text()();

  /// Significant part of [CatalystId] uri. See [CatalystId.toSignificant].
  TextColumn get accountSignificantId => text()();

  /// Username extracted from full [CatalystId]. See [CatalystId.username].
  TextColumn get username => text().nullable()();
}
