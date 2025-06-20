import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:uuid_plus/uuid_plus.dart';

base class Uuid extends FormzInput<String, LocalizedException> {
  final int? version;
  final bool isEmptyAllowed;

  const Uuid.dirty({
    String value = '',
    this.version,
    this.isEmptyAllowed = false,
  }) : super.dirty(value);

  const Uuid.pure({
    String value = '',
    this.version,
    this.isEmptyAllowed = false,
  }) : super.pure(value);

  @override
  LocalizedException? validator(String value) {
    if (value.isEmpty && !isEmptyAllowed) {
      return const UuidValidationLengthException();
    }
    if (value.isEmpty && isEmptyAllowed) {
      return null;
    }

    if (!(UuidValidation.isValidUUID(fromString: value) ||
        UuidValidation.isValidUUID(fromString: value, noDashes: true))) {
      return const UuidValidationFormatException();
    }

    final version = this.version;
    if (version != null) {
      final valueVersion = UuidUtils.tryVersion(value);
      if (valueVersion == null) {
        return const UuidValidationFormatException();
      }
      if (valueVersion != version) {
        return UuidValidationVersionException(version: valueVersion, requiredVersion: version);
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

final class UuidValidationLengthException extends UuidValidationException {
  const UuidValidationLengthException();

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
