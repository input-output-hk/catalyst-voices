import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_resource_conflict_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// An [Exception] that can provide localized, human readable info.
abstract base class LocalizedException with EquatableMixin implements Exception {
  const LocalizedException();

  factory LocalizedException.create(
    Object error, {
    ValueGetter<LocalizedException> fallback = LocalizedUnknownException.new,
  }) {
    if (error is LocalizedException) return error;
    if (error is ApiException) return LocalizedApiException.from(error);
    if (error is NotFoundException) return const LocalizedNotFoundException();
    if (error is DocumentHiddenException) return const LocalizedDocumentHiddenException();
    if (error is ResourceConflictException) {
      return LocalizedResourceConflictException(error.message);
    }

    return fallback();
  }

  @override
  List<Object?> get props => [];

  /// Returns a message describing the exception that can be shown the user.
  ///
  /// Use the [BuildContext] to get the [VoicesLocalizations]
  /// or any other context dependent formatting utilities.
  String message(BuildContext context);
}
