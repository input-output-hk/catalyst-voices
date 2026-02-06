import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final class LocalizedCollaboratorIsNotValidException extends LocalizedException {
  final CollaboratorValidationResult result;
  const LocalizedCollaboratorIsNotValidException(this.result);

  @override
  String message(BuildContext context) {
    return result.message(context);
  }
}
