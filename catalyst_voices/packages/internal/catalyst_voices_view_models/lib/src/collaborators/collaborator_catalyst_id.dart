import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

final class CatalystIdAlreadyAddedValidationException
    extends CollaboratorCatalystIdValidationException {
  const CatalystIdAlreadyAddedValidationException();

  @override
  String message(BuildContext context) {
    return context.l10n.catalystIdAlreadyAddedAsCollaboratorMessage;
  }
}

final class CatalystIdBelongsToMainProposerValidationException
    extends CollaboratorCatalystIdValidationException {
  const CatalystIdBelongsToMainProposerValidationException();

  @override
  String message(BuildContext context) {
    return context.l10n.catalystIdBelongsToMainProposer;
  }
}

final class CollaboratorCatalystId
    extends FormzInput<String, CollaboratorCatalystIdValidationException> {
  final CatalystId? authorCatalystId;
  final List<CatalystId> collaborators;

  const CollaboratorCatalystId.dirty({
    required String value,
    required this.collaborators,
    required this.authorCatalystId,
  }) : super.dirty(value);

  const CollaboratorCatalystId.pure([
    super.value = '',
    this.collaborators = const [],
    this.authorCatalystId,
  ]) : super.pure();

  @override
  CollaboratorCatalystIdValidationException? validator(String value) {
    final authorCatalystId = this.authorCatalystId;
    final catalystId = CatalystId.tryParse(value);
    if (catalystId == null) {
      return const InvalidCatalystIdFormatValidationException();
    } else if (authorCatalystId != null && catalystId.isSameAs(authorCatalystId)) {
      return const CatalystIdBelongsToMainProposerValidationException();
    } else if (collaborators.any((collaborator) => collaborator.isSameAs(catalystId))) {
      return const CatalystIdAlreadyAddedValidationException();
    }
    return null;
  }
}

sealed class CollaboratorCatalystIdValidationException extends LocalizedException {
  const CollaboratorCatalystIdValidationException();
}

final class InvalidCatalystIdFormatValidationException
    extends CollaboratorCatalystIdValidationException {
  const InvalidCatalystIdFormatValidationException();

  @override
  String message(BuildContext context) {
    return context.l10n.catalystIdFormatInvalidMessage;
  }
}
