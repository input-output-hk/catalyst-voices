import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/indicators/voices_linear_progress_indicator.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

typedef OnVoicesFileUploaded = Future<void> Function(VoicesFile value);

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

  static Future<VoicesFile?> show(
    BuildContext context, {
    required String title,
    String? itemNameToUpload,
    String? info,
    List<String>? allowedExtensions,
    OnVoicesFileUploaded? onUpload,
  }) {
    return VoicesDialog.show<VoicesFile?>(
      context: context,
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

  @override
  State<VoicesUploadFileDialog> createState() => _VoicesUploadFileDialogState();
}

class _VoicesUploadFileDialogState extends State<VoicesUploadFileDialog> {
  VoicesFile? _selectedFile;
  bool _isUploading = false;

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
              itemNameToUpload: widget.itemNameToUpload,
              info: widget.info,
              allowedExtensions: widget.allowedExtensions,
              onFileSelected: (file) {
                setState(() {
                  _selectedFile = file;
                });
              },
            ),
            if (_selectedFile != null)
              _InfoContainer(
                selectedFilename: _selectedFile!.name,
                isUploading: _isUploading,
              ),
            const SizedBox(height: 24),
            _Buttons(
              selectedFile: _selectedFile,
              onUpload: (file) async {
                setState(() {
                  _isUploading = true;
                });
                await widget.onUpload?.call(file);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatefulWidget {
  final VoicesFile? selectedFile;
  final OnVoicesFileUploaded? onUpload;

  const _Buttons({
    this.selectedFile,
    this.onUpload,
  });

  @override
  State<_Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<_Buttons> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VoicesOutlinedButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(context.l10n.cancelButtonText),
          ),
        ),
        if (!_isUploading) const SizedBox(width: 8),
        if (!_isUploading)
          Expanded(
            child: VoicesFilledButton(
              onTap: (widget.selectedFile != null)
                  ? () async {
                      setState(() {
                        _isUploading = true;
                      });
                      await widget.onUpload?.call(widget.selectedFile!);

                      if (context.mounted) {
                        Navigator.pop(context, widget.selectedFile);
                      }
                    }
                  : null,
              child: Text(context.l10n.upload),
            ),
          ),
      ],
    );
  }
}

class _InfoContainer extends StatelessWidget {
  final String selectedFilename;
  final bool isUploading;

  const _InfoContainer({
    required this.selectedFilename,
    required this.isUploading,
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
          if (isUploading)
            Flexible(
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    context.l10n.uploadProgressInfo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 480,
                    child: VoicesLinearProgressIndicator(),
                  ),
                ],
              ),
            )
          else
            Text(
              selectedFilename,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}

class _UploadContainer extends StatefulWidget {
  final String itemNameToUpload;
  final String? info;
  final List<String>? allowedExtensions;
  final ValueChanged<VoicesFile>? onFileSelected;

  const _UploadContainer({
    required this.itemNameToUpload,
    this.info,
    this.allowedExtensions,
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
              // We allow drag&drop only on web
              if (kIsWeb)
                DropzoneView(
                  operation: DragOperation.copy,
                  cursor: CursorType.grab,
                  onCreated: (DropzoneViewController ctrl) => setState(() {
                    _dropzoneController = ctrl;
                  }),
                  onDrop: (ev) async {
                    final bytes = await _dropzoneController.getFileData(ev);
                    final name = await _dropzoneController.getFilename(ev);
                    widget.onFileSelected?.call(
                      VoicesFile(
                        name: name,
                        bytes: bytes,
                      ),
                    );
                  },
                ),
              InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: (widget.allowedExtensions != null)
                        ? FileType.custom
                        : FileType.any,
                    allowedExtensions: (widget.allowedExtensions != null)
                        ? widget.allowedExtensions!
                        : null,
                  );
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
                          text: context.l10n
                              .uploadDropInfo(widget.itemNameToUpload),
                          style: Theme.of(context).textTheme.titleSmall,
                          children: <TextSpan>[
                            TextSpan(
                              text: context.l10n.browse,
                              style: TextStyle(
                                color: Theme.of(context).colors.iconsPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.info != null)
                        Text(
                          widget.info!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ]
                        .separatedBy(
                          const SizedBox(
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
