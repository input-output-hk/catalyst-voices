import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UploadActions extends StatelessWidget {
  final VoidCallback? onUploadTap;
  final bool showUpload;
  final bool isCancelEnabled;

  const UploadActions({
    super.key,
    this.onUploadTap,
    this.showUpload = true,
    this.isCancelEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(child: _CancelButton(isEnabled: isCancelEnabled)),
        if (showUpload) Expanded(child: _UploadButton(onTap: onUploadTap)),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  final bool isEnabled;

  const _CancelButton({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: isEnabled ? () => Navigator.of(context).pop() : null,
      child: Text(context.l10n.cancelButtonText),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _UploadButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: Text(context.l10n.upload),
    );
  }
}
