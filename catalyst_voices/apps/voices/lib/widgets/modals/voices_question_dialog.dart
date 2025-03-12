import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_alert_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class VoicesQuestionActionItem extends Equatable {
  final String name;
  final bool isPositive;
  final VoicesQuestionActionType type;

  const VoicesQuestionActionItem.negative(
    this.name, {
    this.type = VoicesQuestionActionType.text,
  }) : isPositive = false;

  const VoicesQuestionActionItem.positive(
    this.name, {
    this.type = VoicesQuestionActionType.filled,
  }) : isPositive = true;

  @override
  List<Object?> get props => [
        name,
        isPositive,
        type,
      ];
}

enum VoicesQuestionActionType { filled, text }

/// Simple dialog when working with yes/no type of dialogs.
///
/// example:
/// ```dart
///     final confirmed = await VoicesQuestionDialog.show(
///      context,
///      builder: (_) => const RegistrationExitConfirmDialog(),
///    );
///```
class VoicesQuestionDialog extends StatelessWidget {
  /// [VoicesAlertDialog.title].
  final Widget title;

  /// [VoicesAlertDialog.icon].
  final Widget? icon;

  /// [VoicesAlertDialog.subtitle].
  final Widget? subtitle;

  /// [VoicesAlertDialog.content].
  final Widget? content;

  /// List of yes/no actions, usually only 2 make sense.
  /// See [VoicesQuestionActionItem] for config details.
  final List<VoicesQuestionActionItem> actions;

  const VoicesQuestionDialog({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAlertDialog(
      title: title,
      icon: icon,
      subtitle: subtitle,
      content: content,
      buttons: actions.map((e) => _buildItem(context, item: e)).toList(),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required VoicesQuestionActionItem item,
  }) {
    switch (item.type) {
      case VoicesQuestionActionType.filled:
        return VoicesFilledButton(
          key: const Key('ButtonFilled'),
          onTap: () => Navigator.of(context).pop(item.isPositive),
          child: Text(item.name),
        );
      case VoicesQuestionActionType.text:
        return VoicesTextButton(
          key: const Key('ButtonText'),
          onTap: () => Navigator.of(context).pop(item.isPositive),
          child: Text(item.name),
        );
    }
  }

  static Future<bool> show(
    BuildContext context, {
    required RouteSettings routeSettings,
    required WidgetBuilder builder,
    bool fallback = false,
  }) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      routeSettings: routeSettings,
      builder: builder,
    );

    return result ?? fallback;
  }
}
