import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:web/web.dart' as web;

class VoicesUploadFileDialog extends StatefulWidget {
  final String title;
  final String? mimeType;
  final Future<dynamic> Function(VoicesFile value)? onUpload;

  const VoicesUploadFileDialog({
    super.key,
    required this.title,
    this.mimeType,
    this.onUpload,
  });

  static Future<VoicesFile?> show(
    BuildContext context, {
    required String title,
    String? mimeType,
    Future<dynamic> Function(VoicesFile value)? onUpload,
  }) {
    return VoicesDialog.show<VoicesFile?>(
      context: context,
      builder: (context) {
        return VoicesUploadFileDialog(
          onUpload: onUpload,
          title: title,
          mimeType: mimeType,
        );
      },
    );
  }

  @override
  State<VoicesUploadFileDialog> createState() => _VoicesUploadFileDialogState();
}

class _VoicesUploadFileDialogState extends State<VoicesUploadFileDialog> {
  VoicesFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 450),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(widget.title),
            const SizedBox(height: 24),
            _UploadContainer(
              onFileSelected: (file) {
                setState(() {
                  _selectedFile = file;
                });
              },
            ),
            if (_selectedFile != null)
              _SelectedFileContainer(filename: _selectedFile!.name),
            const SizedBox(height: 24),
            _Buttons(
              selectedFile: _selectedFile,
              onUpload: widget.onUpload,
            ),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final VoicesFile? selectedFile;
  final Future<dynamic> Function(VoicesFile value)? onUpload;

  const _Buttons({
    this.selectedFile,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VoicesOutlinedButton(
            onTap: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancelButtonText),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: VoicesFilledButton(
            onTap: (selectedFile != null)
                ? () async {
                    await onUpload?.call(selectedFile!);

                    if (context.mounted) {
                      Navigator.pop(context, selectedFile);
                    }
                  }
                : null,
            child: const Text('Upload'),
          ),
        ),
      ],
    );
  }
}

class _SelectedFileContainer extends StatelessWidget {
  final String filename;

  const _SelectedFileContainer({
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colors.iconsPrimary!,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VoicesAssets.icons.documentAdd.buildIcon(
              color: Theme.of(context).colors.iconsPrimary,
              size: 30,
            ),
          ),
          Text(
            filename,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _UploadContainer extends StatefulWidget {
  final ValueChanged<VoicesFile>? onFileSelected;

  const _UploadContainer({
    this.onFileSelected,
  });

  @override
  State<_UploadContainer> createState() => _UploadContainerState();
}

class _UploadContainerState extends State<_UploadContainer> {
  late DropzoneViewController _dropzoneController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          dashPattern: const [8, 6],
          color: Theme.of(context).colors.iconsPrimary!,
          child: Stack(
            children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.grab,
                onCreated: (DropzoneViewController ctrl) => setState(() {
                  _dropzoneController = ctrl;
                }),
                onDrop: (ev) async {
                  if (ev is web.File) {
                    final bytes = await _dropzoneController.getFileData(ev);
                    final name = await _dropzoneController.getFilename(ev);
                    widget.onFileSelected?.call(
                      VoicesFile(
                        name: name,
                        bytes: bytes,
                      ),
                    );
                  }
                },
              ),
              InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles();
                  final file = result?.files.first;
                  final name = file?.name;
                  final bytes = file?.bytes;

                  if (name != null && bytes != null) {
                    widget.onFileSelected?.call(
                      VoicesFile(
                        name: name,
                        bytes: bytes,
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colors.iconsPrimary!,
                            width: 3,
                          ),
                        ),
                        child: VoicesAssets.icons.upload.buildIcon(
                          color: Theme.of(context).colors.iconsPrimary,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Drop your key here or ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'browse',
                              style: TextStyle(
                                color: Theme.of(context).colors.iconsPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Make sure it's a correct Catalyst keychain file.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ]
                        .separatedBy(
                          Container(
                            height: 12,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
