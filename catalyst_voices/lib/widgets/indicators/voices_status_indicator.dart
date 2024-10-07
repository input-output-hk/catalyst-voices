import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// Enum representing the two possible types of status indicators:
/// success or error.
///
/// Type will result in different status colors.
enum VoicesStatusIndicatorType { success, error }

/// A widget that displays a visual indicator of a status along with a
/// title and body text.
///
/// Uses different colors and icons for success and error states.
///
/// Example:
/// ```dart
///     VoicesStatusIndicator(
///       status: AffixDecorator(
///         prefix: Icon(Icons.check),
///         child: Text('QR VERIFIED'),
///       ),
///       title: Text('Your QR code verified successfully'),
///       body: Text('You can now use your QR-code  to login into Catalyst.'),
///       type: VoicesStatusIndicatorType.success,
///     ),
/// ```
class VoicesStatusIndicator extends StatelessWidget {
  /// Typically [Text] or [Row] with [Text] and [Icon].
  final Widget status;

  /// Typically [Text].
  final Widget title;

  /// Typically [Text].
  final Widget body;

  /// Specifies [status] colors configuration.
  final VoicesStatusIndicatorType type;

  const VoicesStatusIndicator({
    super.key,
    required this.status,
    required this.title,
    required this.body,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StatusContainer(
            type: type,
            child: status,
          ),
          _TitleContainer(child: title),
          _BodyContainer(child: body),
        ].separatedBy(const SizedBox(height: 16)).toList(),
      ),
    );
  }
}

class _StatusContainer extends StatelessWidget {
  final VoicesStatusIndicatorType type;
  final Widget child;

  const _StatusContainer({
    required this.type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = switch (type) {
      VoicesStatusIndicatorType.success => theme.colors.success,
      VoicesStatusIndicatorType.error => theme.colorScheme.error,
    };

    final foregroundColor = switch (type) {
      VoicesStatusIndicatorType.success => theme.colors.successContainer,
      VoicesStatusIndicatorType.error => theme.colors.errorContainer,
    };

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: (theme.textTheme.titleLarge ?? const TextStyle())
            .copyWith(color: foregroundColor),
        child: IconTheme(
          data: IconThemeData(
            size: 24,
            color: foregroundColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TitleContainer extends StatelessWidget {
  final Widget child;

  const _TitleContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextStyle(
      style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
        color: theme.colors.textOnPrimary,
      ),
      textAlign: TextAlign.center,
      child: child,
    );
  }
}

class _BodyContainer extends StatelessWidget {
  final Widget child;

  const _BodyContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextStyle(
      style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: theme.colors.textOnPrimary,
      ),
      textAlign: TextAlign.center,
      child: child,
    );
  }
}
