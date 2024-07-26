import 'package:flutter/material.dart';

class CatalystSnackBar extends StatelessWidget {
  final String message;
  final SnackBarType type;
  final List<SnackBarAction> actions;

  factory CatalystSnackBar.show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    VoidCallback? onRefresh,
    VoidCallback? onLearnMore,
    List<SnackBarAction>? customActions,
  }) {
    final defaultActions = [
      if (onRefresh != null)
        SnackBarAction(
          label: 'Refresh',
          onPressed: onRefresh,
        ),
      if (onLearnMore != null)
        SnackBarAction(
          label: 'Learn more',
          onPressed: onLearnMore,
        ),
    ];

    final actions = customActions ?? defaultActions;

    final snackBar = CatalystSnackBar._(
      message: message,
      type: type,
      actions: actions,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
      ),
    );

    return snackBar;
  }

  const CatalystSnackBar._({
    required this.message,
    required this.type,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColorForType(type),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(_getIconForType(type), color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getTitleForType(type),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                if (actions.isNotEmpty) const SizedBox(height: 8),
                Row(
                  children: actions
                      .map(
                        (action) => TextButton(
                          onPressed: action.onPressed,
                          child: Text(
                            action.label,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      ),
    );
  }

  Color _getColorForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return Colors.blue;
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.error:
        return Colors.red;
    }
  }

  IconData _getIconForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return Icons.info_outline;
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.error:
        return Icons.error_outline;
    }
  }

  String _getTitleForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return 'Info';
      case SnackBarType.success:
        return 'Success';
      case SnackBarType.warning:
        return 'Warning';
      case SnackBarType.error:
        return 'Error';
    }
  }
}

enum SnackBarType { info, success, warning, error }
