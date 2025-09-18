import 'package:catalyst_voices/widgets/modals/upload/info_container.dart';
import 'package:catalyst_voices/widgets/modals/upload/upload_actions.dart';
import 'package:catalyst_voices/widgets/modals/upload/upload_container.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_panel_dialog.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

typedef OnVoicesFileUploaded = Future<void> Function(XFile value);

class VoicesUploadFileDialog extends StatefulWidget {
  final String title;
  final String itemNameToUpload;
  final String? info;
  final List<String>? allowedExtensions;
  final OnVoicesFileUploaded? onUpload;

  const VoicesUploadFileDialog({
    super.key,
    required this.title,
    required this.itemNameToUpload,
    this.info,
    this.allowedExtensions,
    this.onUpload,
  });

  @override
  State<VoicesUploadFileDialog> createState() => _VoicesUploadFileDialogState();

  static Future<XFile?> show(
    BuildContext context, {
    required RouteSettings routeSettings,
    required String title,
    String? itemNameToUpload,
    String? info,
    List<String>? allowedExtensions,
    OnVoicesFileUploaded? onUpload,
  }) {
    return VoicesDialog.show<XFile?>(
      context: context,
      routeSettings: routeSettings,
      builder: (context) {
        return VoicesUploadFileDialog(
          title: title,
          itemNameToUpload: itemNameToUpload ?? context.l10n.file,
          info: info,
          allowedExtensions: allowedExtensions,
          onUpload: onUpload,
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  final String data;

  const _Title(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(
      data.toUpperCase(),
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _VoicesUploadFileDialogState extends State<VoicesUploadFileDialog> {
  XFile? _selectedFile;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return VoicesPanelDialog(
      constraints: const Responsive.single(
        BoxConstraints(maxWidth: 600, maxHeight: 450),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(widget.title),
            const SizedBox(height: 24),
            Expanded(
              child: UploadContainer(
                itemNameToUpload: widget.itemNameToUpload,
                info: widget.info,
                allowedExtensions: widget.allowedExtensions,
                onFileSelected: (file) {
                  setState(() {
                    _selectedFile = file;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedFile?.name case final name?)
              InfoContainer(
                selectedFilename: name,
                isUploading: _isUploading,
              ),
            const SizedBox(height: 24),
            UploadActions(
              onUploadTap: !_isUploading ? _uploadSelectedFile : null,
              showUpload: _selectedFile != null,
              isCancelEnabled: !_isUploading,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadSelectedFile() async {
    final selectedFile = _selectedFile;
    assert(selectedFile != null, 'Selected file is not available');

    setState(() {
      _isUploading = true;
    });

    await widget.onUpload?.call(selectedFile!);

    if (mounted) {
      Navigator.pop(context, selectedFile);
    }
  }
}
