import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:uuid_plus/uuid_plus.dart';

final class Uuid extends FormzInput<String, Exception> {
  final int? version;

  const Uuid.dirty({
    String value = '',
    this.version,
  }) : super.dirty(value);

  const Uuid.pure({
    String value = '',
    this.version,
  }) : super.pure(value);

  @override
  Exception? validator(String value) {
    if (!UuidValidation.isValidUUID(fromString: value) &&
        UuidValidation.isValidUUID(fromString: value, noDashes: true)) {
      throw const UuidValidationFormatException();
    }

    final version = this.version;
    if (version != null) {
      final valueVersion = UuidUtils.version(value);
      if (valueVersion != version) {
        throw UuidValidationVersionException(version: valueVersion, requiredVersion: version);
      }
    }

    return null;
  }
}

sealed class UuidValidationException extends LocalizedException {
  const UuidValidationException();
}

final class UuidValidationFormatException extends UuidValidationException {
  const UuidValidationFormatException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorUuidInvalidFormat;
  }
}

final class UuidValidationVersionException extends UuidValidationException {
  final int version;
  final int requiredVersion;

  const UuidValidationVersionException({
    required this.version,
    required this.requiredVersion,
  });

  @override
  String message(BuildContext context) {
    return context.l10n.errorUuidVersionMissMatch(version, requiredVersion);
  }
}
