import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_validation_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:flutter/material.dart';

/// A "scaffold" which inserts the [snackbar] into the widget tree above the [child].
///
/// Intended to work with the [DocumentBuilderValidationSnackbar].
class DocumentBuilderValidationSnackbarScaffold extends StatelessWidget {
  final Widget child;
  final Widget? snackbar;

  const DocumentBuilderValidationSnackbarScaffold({
    super.key,
    required this.child,
    required this.snackbar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (snackbar != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      VoicesSnackBar.calculateSnackBarWidth(
                        behavior: SnackBarBehavior.floating,
                        screenWidth: MediaQuery.sizeOf(context).width,
                      ) ??
                      double.infinity,
                ),
                child: snackbar,
              ),
            ),
          ),
      ],
    );
  }
}
