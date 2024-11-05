import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// An [Exception] that can provide localized, human readable info.
abstract base class LocalizedException
    with EquatableMixin
    implements Exception {
  const LocalizedException();

  /// Returns a message describing the exception that can be shown the user.
  ///
  /// Use the [BuildContext] to get the [VoicesLocalizations]
  /// or any other context dependent formatting utilities.
  String message(BuildContext context);

  @override
  List<Object?> get props => [];
}
