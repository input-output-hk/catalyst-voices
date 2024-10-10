import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A generic error state with optional retry button.
class VoicesSuccessIndicator extends StatelessWidget {
  /// The description of the error.
  final String message;

  /// Usually [VoicesTextButton]. Will be appended at the end of widget.
  final Widget? action;

  const VoicesSuccessIndicator({
    super.key,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIndicator(
      type: VoicesIndicatorType.success,
      icon: VoicesAssets.icons.check,
      message: Text(message),
      action: action,
    );
  }
}
