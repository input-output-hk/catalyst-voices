import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:flutter/material.dart';

/// A widget intended to be used as a main content to indicate
/// an error with the document builder, i.e. when the document
/// builder is not able to load the document.
class DocumentBuilderContentError extends StatelessWidget {
  final String message;
  final VoidCallback onRetryTap;

  const DocumentBuilderContentError({
    super.key,
    required this.message,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VoicesErrorIndicator(
        message: message,
        onRetry: onRetryTap,
      ),
    );
  }
}
