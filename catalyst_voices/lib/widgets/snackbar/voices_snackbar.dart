import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:flutter/material.dart';

class VoicesSnackBar extends StatelessWidget {
  final CatalystSnackBarType snackBarType;
  final List<SnackBarAction> actions;

  factory VoicesSnackBar.show(
    BuildContext context, {
    required CatalystSnackBarType snackBarType,
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

    final snackBar = VoicesSnackBar._(
      snackBarType: snackBarType,
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

  const VoicesSnackBar._({
    required this.snackBarType,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: snackBarType.backgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            snackBarType.icon(context),
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  snackBarType.title(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  snackBarType.message(context),
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
}
